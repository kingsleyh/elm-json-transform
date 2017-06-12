port module Main exposing (..)

import Test exposing (concat)
import JsonTransformTests
import Json.Encode exposing (Value)
import Test.Runner.Node exposing (run, TestProgram)


main : TestProgram
main =
    [ JsonTransformTests.all ]
        |> concat
        |> run emit


port emit : ( String, Value ) -> Cmd msg
