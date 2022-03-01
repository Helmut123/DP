module Components.Button.Button_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {
       storage: Storage
    }

type Storage = Cookies
    | Session
    | Local


init : Model
init = 
    ({
    storage = Local
    })