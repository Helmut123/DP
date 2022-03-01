module Components.Home.Home_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time
import Components.Home.Home_model as Home_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | SwapActive Home_model.Active Int
    | Tick Time.Posix


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp -> 
            model
        SwapActive active carTime ->
            { model | active = active, carouselTime = carTime }
        Tick newTime ->
            if model.carouselTime < 5 then
                { model | active = First, carouselTime = ( changeTime model )}
            else if model.carouselTime >= 5 && model.carouselTime < 10 then
                { model | active = Second, carouselTime = ( changeTime model )}
            else if model.carouselTime >= 10 && model.carouselTime < 15 then
                { model | active = Third, carouselTime = ( changeTime model )}
            else
                { model | active = First, carouselTime = 0}



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model = 
    Time.every 1000 Tick

changeTime : Model -> Int
changeTime model =
    model.carouselTime + 1