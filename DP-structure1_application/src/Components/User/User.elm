module Components.User.User exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional,hardcoded)



---- MODEL ----


type alias Model =
    {
       username : String
{-       , email : String  -}
       , token : String
    }

decodeUser : Decode.Decoder Model
decodeUser =
    Decode.succeed Model
        |> required "username" Decode.string
{-        |> required "email" Decode.string  -}
        |> required "token" Decode.string

    