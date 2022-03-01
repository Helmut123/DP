module Components.Footer.Footer_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {
        page: Page
    }

type Page = Home
    | ToDo
    | Ritual


init : Model
init = 
    ({
    page = Home
    })