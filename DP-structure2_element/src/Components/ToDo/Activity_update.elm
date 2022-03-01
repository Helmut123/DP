module Components.ToDo.Activity_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_, src, id)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.ToDo.Activity_model as Activity_model exposing (..)


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