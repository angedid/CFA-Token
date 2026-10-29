type Subject = String
type Verb = String
type Object = String
data Sentence = Sentence Subject Verb Object deriving (Eq, Show)
s1 = Sentence "dogs" "drool"
s2 = Sentence "Julie" "loves" "dogs"


chk :: Eq b => (a -> b) -> a -> b -> Bool
chk f x y =  (f x) == y


data Status = Multiple Int Char | Singleton Int Char 

giveMeChar :: Status  -> Char
giveMeChar (Multiple n c) = c
giveMeChar (Singleton n c) = c
 
