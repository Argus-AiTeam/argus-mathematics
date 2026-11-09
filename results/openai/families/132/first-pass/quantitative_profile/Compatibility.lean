universe u

theorem ite_eq_left {α : Sort u} {c : Prop} [Decidable c] {a b : α} (h : c) :
    (if c then a else b) = a := if_pos h

theorem ite_eq_right {α : Sort u} {c : Prop} [Decidable c] {a b : α} (h : ¬c) :
    (if c then a else b) = b := if_neg h

theorem dite_eq_left {α : Sort u} {c : Prop} [Decidable c]
    {a : c → α} {b : ¬c → α} (h : c) :
    (if h' : c then a h' else b h') = a h := dif_pos h

theorem dite_eq_right {α : Sort u} {c : Prop} [Decidable c]
    {a : c → α} {b : ¬c → α} (h : ¬c) :
    (if h' : c then a h' else b h') = b h := dif_neg h
