module Components.Home.Home_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


---- MODEL ----


type alias Model =
    {
        active: Active
        , carouselTime: Int
    }

type Active = First
    | Second
    | Third

init : Model
init = ({
        active = First
        , carouselTime = 0
    })