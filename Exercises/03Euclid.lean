import Workshop.ContinuedFractions
import Workshop.Arithmetic

/-! CORE, 28–42 minutes. Run these by clicking the #eval lines; their output
appears in Infoview. Change inputs to 35,12 and then to 12,35 or 0,0.
Predict the final remainder first. No recursion-writing is required.

Compare the adjacent trace and countSteps evaluations below. For 1071,462,
the trace stores three division rows; the counter stores 3. Both return gcd 21.
Change the inputs in BOTH commands. What does each observer record, and what
stays identical? Does observe_result guarantee identical recorded data, or only
identical mathematical answers?
Open Workshop/Euclid.lean and #check Workshop.observe_result and
Workshop.trace_result, Workshop.countSteps_result and Workshop.euclid_eq_gcd.
The first two specialise observe_result to the two observers. Which is a statement about software observation, and
which connects the algorithm to a mathematical specification?
AI: “Explain the quantifiers in observe_result. What can an observer change?” -/
#eval Workshop.trace 1071 462 -- (21, three division rows)
#eval Workshop.countSteps 1071 462 -- (21, 3)
#eval Workshop.display 1071 462 -- the same rows as readable equations
#eval Workshop.extended 1071 462 -- (21, -3, 7): 21 = -3*1071 + 7*462
#eval Workshop.extended 3 7 -- (1, -2, 1): 1 = -2*3 + 7
#eval Nat.gcd 1071 462
#eval (Nat.gcdA 1071 462, Nat.gcdB 1071 462)

/-! Complete ONE theorem. First is finite arithmetic; second reuses a general
algorithm theorem. Explain the difference. Hints: `norm_num`; `exact` followed
by the appropriate Workshop theorem. -/
example : (21 : ℤ) = -3*1071 + 7*462 := by
  sorry
example (a b : ℕ) : Workshop.euclid a b = Nat.gcd a b := by
  sorry

/-! Bridge: -2 is the Bézout coefficient of 3. Its residue is 5 modulo 7.
Verify this inverse. Why does gcd = 1 matter? -/
example : (3 : ZMod 7) * (-2) = 1 := by
  sorry

/-! OPTIONAL, 42–50 minutes. Euclid gives [2;3,7], not [2/3/7].
Change the inputs, inspect quotients, and propose an analogous exact identity.
The checked concrete example is in Workshop/ContinuedFractions.lean.
Stretch: formulate a general statement with correct nonzero hypotheses;
discuss how quotient/remainder identities might prove it. It is not proved here.
AI: “What hypotheses would a general continued-fraction reconstruction need?” -/
#eval Workshop.quotients 1071 462
#eval Workshop.continuedFraction [2, 3, 7]
