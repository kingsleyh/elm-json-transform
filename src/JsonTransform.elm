module JsonTransform
    exposing
        ( forEach
        , nodes
        , remove
        , update
        , condense
        , updateObjectContaining
        )

{-| JsonTransform uses js-traverse to traverse and modify JavaScript object nodes
    that match JSONSelect selectors.

@docs forEach, nodes, remove, update, condense, updateObjectContaining

Given the following json string
obj = {
   "george": {
      "age": 35,
      "movie": "Repo Man"
   },
   "mary": {
      "age": 15,
      "movie": "Twilight"
   }
}

See how this json is transformed in the below functions

-}

import Json.Encode as JE
import Native.JsonTransform
import String.Interpolate exposing(interpolate)
import Regex as R

{-| forEach

Iterates over all matching nodes in the object. The callback gets a special this context.
See js-traverse for all the things you can do to modify and inspect the node with this context.
In addition, js-select adds a this.matches() which will test if the node matches a selector:

func = """
function(node) {
   if (this.matches(".mary > .movie")) {
      this.remove();
   }
}
"""

e.g forEach obj func

returns:

{
   "george": {
      "age": 35,
      "movie": "Repo Man"
   },
   "mary": {
      "age": 15
   }
}

-}
forEach : String -> String -> String
forEach obj func =
    Native.JsonTransform.forEach obj func


{-| nodes

Returns all matching nodes from the object.

e.g. nodes obj ".age"

returns:

[35, 15]

-}
nodes : String -> String -> String
nodes obj selector =
    Native.JsonTransform.nodes obj selector


{-| remove

Removes matching elements from the original object.

e.g. remove obj ".age"

returns:

{
   "george": {
      "movie": "Repo Man"
   },
   "mary": {
      "movie": "Twilight"
   }
}

-}
remove : String -> String -> String
remove obj selector =
    Native.JsonTransform.remove obj selector


{-| update

Updates all matching nodes using the given callback.

func = """
function(age) {
   return age - 5;
}
"""

e.g update obj ".age" func

returns:

{
   "george": {
      "age": 30,
      "movie": "Repo Man"
   },
   "mary": {
      "age": 10,
      "movie": "Twilight"
   }
}

-}
update : String -> String -> String -> String
update obj selector func =
    Native.JsonTransform.update obj selector func


{-| condense

Reduces the original object down to only the matching elements (the hierarchy is maintained).

e.g. condense obj ".age"

returns:

{
    george: { age: 35 },
    mary: { age: 15 }
}

-}
condense : String -> String -> String
condense obj selector =
    Native.JsonTransform.condense obj selector

{-| updateObjectContaining

Updates key/value pairs in an object that is located by a key/value pair that exists inside the object

Note - you must format the value like this:

 strings:  ("movie", "'Repo Man'")  <- use single quotes
 numbers:  ("age", "35")
 arrays :  ("things", ['a','b']) <- use single quotes

e.g. updateObjectContaining obj [("movie","'Repo Man'")] [("movie","'Cars'")]

returns:

{
   "george": {
      "age": 35,
      "movie": "Cars"
   },
   "mary": {
      "age": 15,
      "movie": "Twilight"
   }
}

-}
updateObjectContaining : String -> List (String, String) -> List (String, String) -> String
updateObjectContaining obj keyPairs updateKeyPairs =
  let
    finders = List.map (\(k,v) -> (interpolate "&& node.{0} && node.{0}==={1}") [k, removeQuotes(v)] ) keyPairs
              |> String.join " "

    removeQuotes : String -> String
    removeQuotes v =
      let
       remover = R.replace R.All (R.regex "^\"|\"$") (\_ -> "")
      in
       remover v

    updaters = List.map (\(k,v) -> (interpolate "node.{0}={1};" [k, removeQuotes(v)])) updateKeyPairs
               |> String.join "\n"


    a = Debug.log "finder: " finders
    b = Debug.log "updater: " updaters

    func = interpolate """
        function(node){
          if(node {0}){
            {1}
          }
        }
    """ [finders, updaters]

    result = forEach obj func
  in
   result