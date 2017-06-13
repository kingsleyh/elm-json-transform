module JsonTransformTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Expect exposing (Expectation)
import JsonTransform exposing (forEach, nodes, remove, update, condense)


it : String -> Expect.Expectation -> Test
it title content =
    test title <| \() -> content



-- Reference json


json =
    """{"george":{"age":35,"movie":"Repo Man"},"mary":{"age":15,"movie":"Twilight"}}"""



-- Functions


forEachFunc =
    """
function(node) {
   if (this.matches(".mary > .movie")) {
      this.remove();
   }
}
"""


updateFunc =
    """
function(age) {
   return age - 5;
}
"""



-- Tests


suite : Test
suite =
    describe "JsonTransform"
        [ it "should apply forEach"
            (Expect.equal (forEach json forEachFunc) """{"george":{"age":35,"movie":"Repo Man"},"mary":{"age":15}}""")
        , it "should apply nodes" (Expect.equal (nodes json ".age") "[35,15]")
        , it "should apply remove" (Expect.equal (remove json ".age") """{"george":{"movie":"Repo Man"},"mary":{"movie":"Twilight"}}""")
        , it "should apply update" (Expect.equal (update json ".age" updateFunc) """{"george":{"age":30,"movie":"Repo Man"},"mary":{"age":10,"movie":"Twilight"}}""")
        , it "should apply condense" (Expect.equal (condense json ".age") """{"george":{"age":35},"mary":{"age":15}}""")
        ]
