#!/usr/bin/env python3
"""Regression-check legacy and modern arXiv download IDs without network calls."""

import contextlib
import io
import runpy
import shutil
import tempfile
from pathlib import Path
from urllib.parse import parse_qs, urlsplit


module = runpy.run_path(shutil.which("math-cite"))
arxiv = module["arxiv"]
preprints = module["preprints"]
for ident in ("hep-th/9111026v1", "math/0602151v2", "0909.4499v1"):
    requests = []
    xml = (
        '<feed xmlns="http://www.w3.org/2005/Atom"><entry>'
        f"<id>http://arxiv.org/abs/{ident}</id><title>Test paper</title>"
        "<author><name>Test Author</name></author>"
        "<published>2001-01-01</published><updated>2001-01-02</updated>"
        "</entry></feed>"
    ).encode()

    def get(url):
        requests.append(url)
        if "/api/query?" in url:
            return xml, "application/atom+xml", url
        if "/pdf/" in url:
            return b"%PDF-1.0\n", "application/pdf", url
        if "/e-print/" in url:
            return b"test source", "application/x-tex", url
        raise AssertionError(url)

    arxiv.__globals__["get"] = get
    with tempfile.TemporaryDirectory() as directory:
        with contextlib.redirect_stdout(io.StringIO()) as output:
            assert arxiv(ident, Path(directory)) == 0
        assert parse_qs(urlsplit(requests[0]).query)["id_list"] == [ident]
        assert f"https://arxiv.org/pdf/{ident}" in requests
        assert f"https://arxiv.org/e-print/{ident}" in requests
        assert f"arXiv:{ident}" in output.getvalue()
        assert (Path(directory) / f"arxiv-{ident.replace('/', '_')}.pdf").exists()
    with contextlib.redirect_stdout(io.StringIO()) as output:
        preprints("Test paper")
    assert f"arXiv preprint: {ident}" in output.getvalue()
    print(f"PASS exact version, download URLs, filenames and DOI suggestion: {ident}")
