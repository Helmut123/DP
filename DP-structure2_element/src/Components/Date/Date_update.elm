module Components.Date.Date_update exposing (..)

import TimeZone
import Time exposing(Month, toDay, toMonth, toYear)
import Components.Date.Date_model as Date_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

getDay : Time.Posix -> Int
getDay time =
    let
        timeZone = TimeZone.europe__bratislava ()
    in
        Time.toDay timeZone time

getMonth : Time.Posix -> Int
getMonth time =
    let
        timeZone = TimeZone.europe__bratislava ()
    in
        monthToInt(Time.toMonth timeZone time)

getYear : Time.Posix -> Int
getYear time =
    let
        timeZone = TimeZone.europe__bratislava ()
    in
        Time.toYear timeZone time

getDate : Int -> Int -> Int -> String
getDate day month year =
    String.fromInt(day)
    ++ "."
    ++ String.fromInt(month)
    ++ "."
    ++ String.fromInt(year)

getDateMinus : Int -> Int -> Int -> String
getDateMinus day month year =
    let
        timeZone = TimeZone.europe__bratislava ()
    in
        if day == 1 then
            if month == 2 || month == 4 || month == 6 || month == 8 || month == 9 || month == 11 then
                "31"
                ++ "."
                ++ String.fromInt(month-1)
                ++ "."
                ++ String.fromInt(year)
            else if month == 3 || month == 5 || month == 7 || month == 10 || month == 12 then
                "30"
                ++ "."
                ++ String.fromInt(month-1)
                ++ "."
                ++ String.fromInt(year)
            else
                "31"
                ++ "."
                ++ "12"
                ++ "."
                ++ String.fromInt(year-1)
        else
            String.fromInt(day-1)
            ++ "."
            ++ String.fromInt(month)
            ++ "."
            ++ String.fromInt(year)

monthToInt : Time.Month -> Int
monthToInt month =
    case month of
        Time.Jan ->
            1
        Time.Feb ->
            2
        Time.Mar ->
            3
        Time.Apr ->
            4
        Time.May ->
            5
        Time.Jun ->
            6
        Time.Jul ->
            7
        Time.Aug ->
            8
        Time.Sep ->
            9
        Time.Oct ->
            10
        Time.Nov ->
            11
        Time.Dec ->
            12