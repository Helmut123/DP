module Components.ToDo.ToDo_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Task
import List.Extra exposing (removeAt, getAt)
{- import Components.ToDo.Activity as Activity exposing (..) -}
import Components.ToDo.Activity_model as Activity_model exposing (..)
import Components.Date.Date_update as Date_update exposing (..)
import Components.User.User as User exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Http


---- MODEL ----


type alias Model =
    {
    activities : List Activity_model.Model
    , activity_text : String
    , activity_warning : Int
    , done_right : List Activity_model.Model
    , done_left : List Activity_model.Model
    , day : Int
    , month : Int
    , year : Int
    , act_time : Time.Posix
    , usable : Bool
    , activity : Activity_model.Model
    , status : Status
    , username : String
    }

type Status
    = Empty
    | Failure Http.Error
    | Success String