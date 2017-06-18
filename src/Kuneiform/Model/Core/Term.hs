module Kuneiform.Model.Core.Term where

import Data.Text
import Kuneiform.Model.Core.Literal
import Kuneiform.Model.Core.Var

data Term
  = TermVar Var
  | TermLam Text Term Term
  | TermApp Term Term
  | TermLit Literal
  deriving (Eq, Show)

shift :: Int -> Var -> Term -> Term
shift d (Var n x) (TermVar (Var n' x')) = TermVar (Var n' x'')
  where x'' = if n == n' && x <= x' then x' + d else x'
shift d (Var n x) (TermLam n' a b) =  TermLam n' a' b'
  where a' = shift d (Var n x ) a
        b' = shift d (Var n x') b
        x' = if n == n' then x + 1 else x
shift _ _         (TermLit a) = TermLit a
shift d v (TermApp f a) = TermApp f' a'
  where f' = shift d v f
        a' = shift d v a

subst :: Var -> Term -> Term -> Term
subst v e (TermVar v') = if v == v' then e else TermVar v'
subst (Var n x) e (TermLam o a b) = TermLam o a' b'
  where a'  = subst (Var n x )                    e   a
        b'  = subst (Var n x') (shift 1 (Var o 0) e)  b
        x'  = if n == o then x + 1 else x
subst v e (TermApp f a) = TermApp f' a'
  where f' = subst v e f
        a' = subst v e a
subst _ _ (TermLit a) = TermLit a

normalize :: Term -> Term
normalize e = case e of
  TermVar v -> TermVar v
  TermLam n a b -> TermLam n a' b'
    where a' = normalize a
          b'  = normalize b
  TermApp f a -> case normalize f of
      TermLam n _A b -> normalize b''  -- Beta reduce
        where a'  = shift   1  (Var n 0) a
              b'  = subst (Var n 0) a' b
              b'' = shift (-1) (Var n 0) b'
      f' -> f'
  TermLit a -> TermLit a
