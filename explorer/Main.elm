module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import JsonTransform as JT


main =
    Html.program
        { init = ( Model "" "" "" "", Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- Model


type alias Model =
    { json : String
    , func : String
    , selector : String
    , result : String
    }



-- Update


type Msg
    = RunForeach
    | RunNodes
    | RunRemove
    | RunUpdate
    | RunCondense
    | UpdateJson String
    | UpdateFunc String
    | UpdateSelector String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RunForeach ->
            let
                json =
                    model.json

                f =
                    model.func

                result =
                    JT.forEach json f
            in
                ( { model | result = result }, Cmd.none )

        RunNodes ->
            let
                json =
                    model.json

                selector =
                    model.selector

                result =
                    JT.nodes json selector
            in
                ( { model | result = result }, Cmd.none )

        RunRemove ->
            let
                json =
                    model.json

                selector =
                    model.selector

                result =
                    JT.remove json selector
            in
                ( { model | result = result }, Cmd.none )

        RunUpdate ->
            let
                json =
                    model.json

                f =
                    model.func

                selector =
                    model.selector

                result =
                    JT.update json selector f
            in
                ( { model | result = result }, Cmd.none )

        RunCondense ->
            let
                json =
                    model.json

                selector =
                    model.selector

                result =
                    JT.condense json selector
            in
                ( { model | result = result }, Cmd.none )

        UpdateJson json ->
            ( { model | json = json }, Cmd.none )

        UpdateFunc func ->
            ( { model | func = func }, Cmd.none )

        UpdateSelector selector ->
            ( { model | selector = selector }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ h2 [] [ text "Json" ]
            , textarea [ onInput UpdateJson, rows 20, cols 20 ] []
            ]
        , div []
            [ h2 [] [ text "Transform" ]
            , div []
                [ div []
                    [ h4 [] [ text "forEach" ]
                    , table []
                        [ tr []
                            [ th [] [ text "function" ]
                            , th [] [ text "action" ]
                            ]
                        , tr []
                            [ td [] [ textarea [ onInput UpdateFunc, rows 10, cols 10 ] [] ]
                            , td [] [ button [ onClick RunForeach ] [ text "Transform forEach" ] ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [] [ text "nodes" ]
                    , table []
                        [ tr []
                            [ th [] [ text "selector" ]
                            , th [] [ text "action" ]
                            ]
                        , tr []
                            [ td [] [ input [ onInput UpdateSelector ] [] ]
                            , td [] [ button [ onClick RunNodes ] [ text "Transform nodes" ] ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [] [ text "remove" ]
                    , table []
                        [ tr []
                            [ th [] [ text "selector" ]
                            , th [] [ text "action" ]
                            ]
                        , tr []
                            [ td [] [ input [ onInput UpdateSelector ] [] ]
                            , td [] [ button [ onClick RunRemove ] [ text "Transform remove" ] ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [] [ text "update" ]
                    , table []
                        [ tr []
                            [ th [] [ text "selector" ]
                            , th [] [ text "function" ]
                            , th [] [ text "action" ]
                            ]
                        , tr []
                            [ td [] [ textarea [ onInput UpdateSelector, rows 10, cols 10 ] [] ]
                            , td [] [ textarea [ onInput UpdateFunc, rows 10, cols 10 ] [] ]
                            , td [] [ button [ onClick RunUpdate ] [ text "Transform update" ] ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [] [ text "condense" ]
                    , table []
                        [ tr []
                            [ th [] [ text "selector" ]
                            , th [] [ text "action" ]
                            ]
                        , tr []
                            [ td [] [ input [ onInput UpdateSelector ] [] ]
                            , td [] [ button [ onClick RunCondense ] [ text "Transform condense" ] ]
                            ]
                        ]
                    ]
                ]
            ]
        , div []
            [ h2 [] [ text "Result" ]
            , textarea [ rows 20, cols 20, value model.result ] []
            ]
        ]
