module Components.LogIn.Signup_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Components.User.User as User exposing (..)


---- MODEL ----


type alias Model =
    { username : String
    , password : String
    , repassword: String
    , email : String
    , warning : Int
    , status : Status
    }


type Status
    = Empty
    | Failure Http.Error
    | Success String