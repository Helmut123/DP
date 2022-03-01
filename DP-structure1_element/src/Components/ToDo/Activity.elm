module Components.ToDo.Activity exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_, src, id)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)


---- MODEL ----


type alias Model =
    {
    name : String
    , active : Bool
    , id : Int
    }


init : Model
init = ( Model "" True -1 )



---- UPDATE ----


type Msg
    = NoOp
    | AcitivityDone 
    | AcitivityRemove


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            ( model )
        AcitivityDone ->
            ( model )
        AcitivityRemove ->
            ( model )


getModel : String -> Bool -> Int -> Model
getModel name active id =
    {
    name = name
    , active = active
    , id = id
    }

decodeActivity : Decode.Decoder Model
decodeActivity =
    Decode.succeed Model
        |> required "name" Decode.string
        |> required "active" Decode.bool
        |> required "id" Decode.int

getId : Maybe Model -> Int
getId model =
    case model of
        Nothing ->
            -1
        Just modelA ->
            modelA.id

---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "" ]
    [
        div[ class "activity" ]
        [
            div[ class "activity_info" ]
            [
                p[][ text model.name ]
            ]
            , div[ class "activity_edit" ]
            [
                a[ onClick AcitivityDone ][ img [ src "approve.png", id "approve" ][] ]
                , a[ onClick AcitivityRemove ][ img [ src "deny.png", id "deny" ][] ]
            ]
        ]
    ]
    