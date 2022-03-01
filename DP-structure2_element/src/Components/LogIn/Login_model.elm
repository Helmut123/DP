module Components.LogIn.Login_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.User.User as User exposing (..)


---- MODEL ----


type alias Model =
    { username : String 
    , password : String
    , warning : Int
    , status : Status
    }

type Status
    = Empty
    | Failure Http.Error
    | Success String


