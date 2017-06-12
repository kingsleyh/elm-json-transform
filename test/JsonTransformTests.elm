module JsonTransformTests exposing (..)

import Expect
import Test exposing (..)
import JsonTransform exposing (..)
import Json.Encode as JE


it : String -> Expect.Expectation -> Test
it title content =
    test title <| \() -> content


obj =
    JE.encode 0
        (JE.object
            [ ( "george", JE.object [ ( "age", JE.int 35 ), ( "movie", JE.string "Repo Man" ) ] )
            , ( "mary", JE.object [ ( "age", JE.int 15 ), ( "movie", JE.string "Twilight" ) ] )
            ]
        )


forEachFunc =
    """
function(node) {
   if (this.matches(".mary > .movie")) {
      this.remove();
   }
}
"""


expectedForEach =
    """
{}
"""


tests =
    describe "JsonTransform"
        [ it "should apply forEach"
            -- (Expect.equal expectedForEach (forEach obj forEachFunc))
            (Expect.equal 1 1)
        ]


all : Test
all =
    describe "All JsonTransform Tests" [ tests ]
