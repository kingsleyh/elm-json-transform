module Main exposing (..)

import Html exposing (text)
import Json.Encode as JE
import JsonTransform exposing (..)
import Array exposing (..)


-- select(people, ".age").update(function(age) {
--    return age - 5;
-- });
-- makeYounger Int ->
-- makeYounger : a -> a
-- makeYounger age =
--     age - 5


main =
    let
        obj =
            JE.object
                [ ( "george", JE.object [ ( "age", JE.int 35 ), ( "movie", JE.string "Repo Man" ) ] )
                , ( "mary", JE.object [ ( "age", JE.int 15 ), ( "movie", JE.string "Twilight" ) ] )
                ]

        -- func =
        --     "function(age){return age - 5;}"
        --
        -- a =
        --     update (JE.encode 0 obj) ".age" func
        --
        -- a1 =
        --     Debug.log "RES: " a
        forEachFunc =
            """
        function(node) {
         if (this.matches(".mary > .movie")) {
         this.remove();
        }
       }
      """

        a =
            forEach (JE.encode 0 obj) forEachFunc

        a1 =
            Debug.log "RES: " a

        -- a =
        --     nodes obj ".age"
        --
        -- a1 =
        --     Debug.log "WAS: " a
        -- b =
        --     update obj ".age" (\age -> age - 5)
        --
        -- b1 =
        --     Debug.log "RES: " b
        -- c =
        --     hello (\s -> JE.array (Array.fromList [ JE.string s ]))
        --
        -- c1 =
        --     Debug.log "HELLO: " c
        --
        -- b =
        --     Debug.log "wooop" "yay"
    in
        text "Hello"
