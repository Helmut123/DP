module Components.ToDo.ToDo_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Task
import List.Extra exposing (removeAt, getAt)
{- import Components.ToDo.Activity as Activity exposing (..) -}
import Components.Date.Date_update as Date_update exposing (..)
import Components.User.User as User exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Http
import Components.ToDo.ToDo_model as ToDo_model exposing (..)
import Components.ToDo.ToDo_update as ToDo_update exposing (..)


---- VIEW ----


view : ToDo_model.Model -> Html ToDo_update.Msg
view model =
    div[ class "to_do_component" ]
    [
        div[ class "to_do" ]
        [
            a[ class "to_do_move", id "to_do_left", onClick ChangeMinus ][ text "<" ]
            , case model.usable of
                True ->
                    a[ class "to_do_move", id "to_do_right", onClick ChangePlus ][ text ">" ]
                False ->
                    a[ class "to_do_move to_do_unusable", id "to_do_right", onClick ChangePlus ][ text ">" ]
            
            , div[ class "to_do_body" ]
            [
                div[ class "to_do_day" ]
                [
                    h2[][ text ( Date_update.getDateMinus model.day model.month model.year ) ]
                    , div[ class "activities" ][
                        div[ class "done" ]( List.indexedMap (\index activity -> viewActivity index activity) (List.filter isNotActive model.done_left) )
                    ]
                ]
                , div[ id "today", class "to_do_day" ]
                [
                    h2[][ text ( Date_update.getDate model.day model.month model.year ) ]
                    , div[ class "activities" ]
                    [
                        div[] ( List.indexedMap (\index activity -> viewActivity index activity) (List.filter isActive model.activities) )
                        , div[ class "done" ]( List.indexedMap (\index activity -> viewActivity index activity) (List.filter isNotActive model.done_right) ) {- ( List.map Activity.view model.done_right ) -}
                    ]
                ]
            ]
            , div[ class "to_do_buttons" ]
            [
                input[ type_ "text", placeholder "Activity Name", Html.Attributes.value model.activity_text, onInput Text ][]
                , a[ onClick AddActivity ][ text "Add activity" ]
                , case model.activity_warning of
                    1 ->
                        p[ class "to_do_warning" ][ text "Add activity name!" ]
                    _ ->
                        p[ class "to_do_warning" ][ text " " ]
            ]
        ]
    ]
    