module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import JsonTransform as JT
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Button as Button
import Bootstrap.ListGroup as Listgroup
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Form.Input as Input
import Bootstrap.Form as Form
import Bootstrap.CDN as CDN


main =
    Html.program
        { init = ( Model "" "" "" "" "" "" "", Cmd.none )
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
    , transformation : String
    , finders : String
    , updaters : String
    }



-- Update


type Msg
    = RunForeach
    | RunNodes
    | RunRemove
    | RunUpdate
    | RunCondense
    | RunObjectContaining
    | UpdateJson String
    | UpdateFunc String
    | UpdateSelector String
    | UpdateFinders String
    | UpdateUpdaters String
    | ChooseTransformation String


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

        RunObjectContaining ->
            let
                json =
                    model.json

                makePairs : String -> ( String, String )
                makePairs value =
                    let
                        tokens =
                            String.split ":" value
                    in
                        ( (Maybe.withDefault "" (List.head tokens)), (Maybe.withDefault "" (tokens |> List.reverse |> List.head)) )

                finders =
                    model.finders
                        |> String.split ","
                        |> List.map (\p -> makePairs p)

                updaters =
                    model.updaters
                        |> String.split ","
                        |> List.map (\p -> makePairs p)

                result =
                    JT.updateObjectContaining json finders updaters
            in
                ( { model | result = result }, Cmd.none )

        ChooseTransformation transformation ->
            ( { model | transformation = transformation }, Cmd.none )

        UpdateJson json ->
            ( { model | json = json }, Cmd.none )

        UpdateFunc func ->
            ( { model | func = func }, Cmd.none )

        UpdateSelector selector ->
            ( { model | selector = selector }, Cmd.none )

        UpdateFinders finders ->
            ( { model | finders = finders }, Cmd.none )

        UpdateUpdaters updaters ->
            ( { model | updaters = updaters }, Cmd.none )



-- View


showCurrentTransform model =
    case model.transformation of
        "forEach" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "forEach" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter a function to apply:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "func"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateFunc
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunForeach, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        "nodes" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "nodes" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter a selector:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "selector"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateSelector
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunNodes, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        "remove" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "remove" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter a selector:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "selector"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateSelector
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunRemove, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        "update" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "update" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter a selector:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "selector"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateSelector
                            ]
                    , Card.text [] [ text "Enter a function:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "func"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateFunc
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunUpdate, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        "condense" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "condense" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter a selector:" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "selector"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateSelector
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunCondense, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        "updateObjectContaining" ->
            Card.config [ Card.outlineInfo, Card.attrs [ style [ ( "margin-top", "20px" ) ] ] ]
                |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "update" ]
                |> Card.block []
                    [ Card.text [] [ text "Enter finder pairs in this format: key1:value1,key2:value2" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "finders"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateFinders
                            ]
                    , Card.text [] [ text "Enter updater pairs in this format: key1:value1,key2:value2" ]
                    , Card.custom <|
                        Textarea.textarea
                            [ Textarea.id "updaters"
                            , Textarea.rows 4
                            , Textarea.onInput UpdateUpdaters
                            ]
                    , Card.custom <| Button.button [ Button.onClick RunObjectContaining, Button.info, Button.attrs [ style [ ( "margin-top", "10px" ) ] ] ] [ text "Transform" ]
                    ]
                |> Card.view

        _ ->
            text ""


selectTransform =
    Select.select
        [ Select.id "myselect"
        , Select.onChange ChooseTransformation
        ]
        [ Select.item [ value "choose" ] [ text "choose a transformation" ]
        , Select.item [ value "forEach" ] [ text "forEach" ]
        , Select.item [ value "nodes" ] [ text "nodes" ]
        , Select.item [ value "remove" ] [ text "remove" ]
        , Select.item [ value "update" ] [ text "update" ]
        , Select.item [ value "condense" ] [ text "condense" ]
        , Select.item [ value "updateObjectContaining" ] [ text "updateObjectContaining" ]
        ]


transform model =
    Card.config [ Card.outlinePrimary ]
        |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "Transform" ]
        |> Card.block []
            [ Card.text [] [ text "Choose a transformation" ]
            , Card.custom <| selectTransform
            , Card.custom <| showCurrentTransform model
            ]
        |> Card.view


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , h3 [] [ text "Elm Json Transform - Explorer" ]
        , Grid.row []
            [ Grid.col [ Col.xl ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "Json" ]
                    |> Card.block []
                        [ Card.text [] [ text "Paste the json you want to modify here." ]
                        , Card.custom <|
                            Textarea.textarea
                                [ Textarea.id "json"
                                , Textarea.rows 20
                                , Textarea.onInput UpdateJson
                                ]
                        ]
                    |> Card.view
                ]
            , Grid.col [] [ transform model ]
            , Grid.col [ Col.xl ]
                [ Card.config [ Card.outlinePrimary ]
                    |> Card.headerH4 [ style [ ( "text-align", "center" ) ] ] [ text "Result" ]
                    |> Card.block []
                        [ Card.text [] [ text "This is the modifed json result" ]
                        , Card.custom <|
                            Textarea.textarea
                                [ Textarea.id "result"
                                , Textarea.rows 20
                                , Textarea.value model.result
                                ]
                        ]
                    |> Card.view
                ]
            ]
        ]
