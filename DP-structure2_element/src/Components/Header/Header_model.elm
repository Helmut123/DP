module Components.Header.Header_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {
        page: Page
        , logged : Bool
    }


type Page = Login
    | Signup

init : Model
init = 
    ({
    page = Login
    , logged = False
    })