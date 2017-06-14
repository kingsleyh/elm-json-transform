module JsonTransformTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Expect exposing (Expectation)
import JsonTransform exposing (forEach, nodes, remove, update, condense, updateObjectContaining )


it : String -> Expect.Expectation -> Test
it title content =
    test title <| \() -> content



-- Reference json


json =
    """{"george":{"age":35,"movie":"Repo Man"},"mary":{"age":15,"movie":"Twilight"}}"""

json2 =
    """{"things":[{"key":"repo-man","movie":"Repo Man","rating":7,"isRented":false},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}"""

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
        , it "should apply updateObjectContaining for strings" (Expect.equal (updateObjectContaining json2 [("key","'repo-man'")] [("movie","'Demolition Man'")]) """{"things":[{"key":"repo-man","movie":"Demolition Man","rating":7,"isRented":false},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}""")
        , it "should apply updateObjectContaining for numbers" (Expect.equal (updateObjectContaining json2 [("key","'repo-man'")] [("rating","9")]) """{"things":[{"key":"repo-man","movie":"Repo Man","rating":9,"isRented":false},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}""")
        , it "should apply updateObjectContaining for arrays" (Expect.equal (updateObjectContaining json2 [("key","'repo-man'")] [("rating","""["a","b"]""")]) """{"things":[{"key":"repo-man","movie":"Repo Man","rating":[\"a\",\"b\"],"isRented":false},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}""")
        , it "should apply updateObjectContaining for bools" (Expect.equal (updateObjectContaining json2 [("key","'repo-man'")] [("isRented", "true")]) """{"things":[{"key":"repo-man","movie":"Repo Man","rating":7,"isRented":true},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}""")
        , it "should apply updateObjectContaining for objects" (Expect.equal (updateObjectContaining json2 [("key","'repo-man'")] [("isRented", """{"apple":"green"}""")]) """{"things":[{"key":"repo-man","movie":"Repo Man","rating":7,"isRented":{\"apple\":\"green\"}},{"key":"twilight","movie":"Twilight","rating":8,"isRented":true}]}""")
        ]
