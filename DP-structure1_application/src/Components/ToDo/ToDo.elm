module Components.ToDo.ToDo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Task
import List.Extra exposing (removeAt, getAt)
import Components.ToDo.Activity as Activity exposing (..)
import Components.Date.Date as Date exposing (..)
import Components.User.User as User exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Http


---- MODEL ----


type alias Model =
    {
    activities : List Activity.Model
    , activity_text : String
    , activity_warning : Int
    , done_right : List Activity.Model
    , done_left : List Activity.Model
    , day : Int
    , month : Int
    , year : Int
    , act_time : Time.Posix
    , usable : Bool
    , activity : Activity.Model
    , status : Status
    , username : String
    }


init : Maybe User.Model -> ( Model, Cmd Msg )
init user = 
    case user of
        Nothing ->
            ( Model [] "" 0 [] [] 0 0 0 (Time.millisToPosix 0) False Activity.init  Empty "", getTime )
        Just userA ->
            ( Model [] "" 0 [] [] 0 0 0 (Time.millisToPosix 0) False Activity.init  Empty userA.username, getTime )


---- UPDATE ----


type Msg
    = NoOp
    | AddActivity
    | Text String
    | ChangeMinus
    | ChangePlus
    | Activity_msg Int Activity.Msg
    | Response (Result Http.Error Activity.Model)
    | OnTime Time.Posix
    | LoadActivities (Result Http.Error (List Activity.Model))
    | LoadDoneA (Result Http.Error (List Activity.Model))
    | LoadDoneB (Result Http.Error (List Activity.Model))

type Status
    = Empty
    | Failure Http.Error
    | Success String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        OnTime time ->
            ({ model | day = Date.getDay time, month = Date.getMonth time, year = Date.getYear time, act_time = time }, Cmd.none )
        AddActivity ->
            case model.activity_text of
                "" ->
                    ({ model | activity_warning = 1 }, Cmd.none )
                _ ->
                    ({ model | activity_text = "", activities = [] }, createActivity model )
        Text text ->
            ( { model | activity_text = text }, Cmd.none )
        ChangeMinus ->
            case model.day of
                1 ->
                    if model.month == 2 || model.month == 4 || model.month == 6 || model.month == 8 || model.month == 9 || model.month == 11 then
                        ({ model | day = 31, month = model.month-1, usable = True, activities = [] }, Cmd.batch [ getDoneAA model.username 31 (model.month-1) model.year, getDoneBB model.username 31 (model.month-1) model.year] )
                    else if model.month == 3 || model.month == 5 || model.month == 7 || model.month == 10 || model.month == 12 then
                        ({ model | day = 30, month = model.month-1, usable = True, activities = [] }, Cmd.batch [ getDoneAA model.username 30 (model.month-1) model.year, getDoneBB model.username 30 (model.month-1) model.year ] )
                    else
                        ({ model | day = 31, month = 12, year = model.year-1, usable = True, activities = [] }, Cmd.batch [ getDoneAA model.username 31 12 (model.year-1), getDoneBB model.username 31 12 (model.year-1) ] )
                _ ->
                    ({ model | day = model.day-1, usable = True, activities = [] }, Cmd.batch [ getDoneAA model.username (model.day-1) model.month model.year, getDoneBB model.username (model.day-1) model.month model.year ] )         
        ChangePlus ->
            if model.month == 2 || model.month == 4 || model.month == 6 || model.month == 8 || model.month == 9 || model.month == 11 then
                case model.day of
                    30 ->
                        if 1 == (Date.getDay model.act_time) && model.month+1 == (Date.getMonth model.act_time) && model.year == (Date.getYear model.act_time) then
                            ({ model | day = 1, month = model.month+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = 1, month = model.month+1 }, Cmd.batch [ getDoneAA model.username 1 (model.month+1) model.year, getDoneBB model.username 1 (model.month+1) model.year ] )
                    _ ->
                        if model.day+1 == (Date.getDay model.act_time) && model.month == (Date.getMonth model.act_time) && model.year == (Date.getYear model.act_time) then
                            ({ model | day = model.day+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = model.day+1 }, Cmd.batch [ getDoneAA model.username (model.day+1) model.month model.year, getDoneBB model.username (model.day+1) model.month model.year ] )
            else if model.month == 3 || model.month == 5 || model.month == 7 || model.month == 10 || model.month == 1 then
                case model.day of
                    31 ->
                        if 1 == (Date.getDay model.act_time) && model.month+1 == (Date.getMonth model.act_time) && model.year == (Date.getYear model.act_time) then
                            ({ model | day = 1, month = model.month+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = 1, month = model.month+1 }, Cmd.batch [ getDoneAA model.username 1 (model.month+1) model.year, getDoneBB model.username 1 (model.month+1) model.year ] )
                    _ ->
                        if model.day+1 == (Date.getDay model.act_time) && model.month == (Date.getMonth model.act_time) && model.year == (Date.getYear model.act_time) then
                            ({ model | day = model.day+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = model.day+1 }, Cmd.batch [ getDoneAA model.username (model.day+1) model.month model.year, getDoneBB model.username (model.day+1) model.month model.year ] )
            else
                case model.day of
                    31 ->
                        if 1 == (Date.getDay model.act_time) && 1 == (Date.getMonth model.act_time) && model.year+1 == (Date.getYear model.act_time) then
                            ({ model | day = 1, month = 1, year = model.year+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = 1, month = 1, year = model.year+1 }, Cmd.batch [ getDoneAA model.username 1 1 (model.year+1), getDoneBB model.username 1 1 (model.year+1) ] )
                    _ ->
                        if model.day+1 == (Date.getDay model.act_time) && model.month == (Date.getMonth model.act_time) && model.year == (Date.getYear model.act_time) then
                            ({ model | day = model.day+1, usable = False }, getActivitiesA model.username )
                        else
                            ({ model | day = model.day+1 }, Cmd.batch [ getDoneAA model.username (model.day+1) model.month model.year, getDoneBB model.username (model.day+1) model.month model.year ] )
        Activity_msg ind childMsg ->
            case childMsg of
                AcitivityRemove ->
                    ( { model | activities = [] }, removeActivity (getId (getAt ind model.activities)) )
                AcitivityDone ->
                    ( { model | activities = [] }, doneActivity (getId (getAt ind model.activities)) (Date.getDate model.day model.month model.year) )
                _ ->
                    ( { model | activities = List.filter isActive (List.indexedMap (\index activity -> 
                        if index == ind then
                            Activity.update childMsg activity
                        else
                            activity) model.activities) }, Cmd.none )
        Response response ->
            case response of
                Ok activity ->
                    ( { model | status = Success "" }, getActivitiesA model.username )
                Err log ->
                    ( { model | status = Failure log }, Cmd.none )
        LoadActivities response ->
            case response of
                Ok activities ->
                    ( { model | activities = activities }, Cmd.batch [ getDoneAA model.username model.day model.month model.year, getDoneBB model.username model.day model.month model.year ] )
                Err _ ->
                    ( model , Cmd.none )
        LoadDoneA response ->
            case response of
                Ok activities ->
                    ( { model | done_right = activities }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )
        LoadDoneB response ->
            case response of
                Ok activities ->
                    ( { model | done_left = activities }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )

getTime : Cmd Msg
getTime =
    Task.perform OnTime Time.now

isActive : Activity.Model -> Bool
isActive activity_model =
    if activity_model.active then
        True
    else
        False

isNotActive : Activity.Model -> Bool
isNotActive activity_model =
    if activity_model.active == False then
        True
    else
        False

viewActivity : Int -> Activity.Model -> Html Msg
viewActivity index activity =
    Activity.view activity |> Html.map ( Activity_msg index )

getModel : ( Model, Cmd Msg ) -> Model
getModel  ( model, msg ) =
    model

encodeActivity : Model -> Encode.Value
encodeActivity model =
    Encode.object[
        ("username", Encode.string model.username)
        , ("name", Encode.string model.activity_text)
        , ("active", Encode.bool True)
    ]

createActivity : Model -> Cmd Msg
createActivity model =
    Http.post
    {
        url = "http://localhost:5000/addActivity"
        , body = Http.jsonBody <| encodeActivity model
        , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
    }

encodeId : Int -> Encode.Value
encodeId id = 
    Encode.object[
        ("id", Encode.int id)
    ]

removeActivity : Int -> Cmd Msg
removeActivity id =
    Http.post
    {
        url = "http://localhost:5000/removeActivity"
        , body = Http.jsonBody <| encodeId id
        , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
    } 

encodeIdDate : Int -> String -> Encode.Value
encodeIdDate id date = 
    Encode.object[
        ("id", Encode.int id)
        , ("date", Encode.string date)
    ]

doneActivity : Int -> String -> Cmd Msg
doneActivity id date = 
    Http.post
    {
        url = "http://localhost:5000/doneActivity"
        , body = Http.jsonBody <| encodeIdDate id date
        , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
    } 

getActivities : Maybe User.Model -> Cmd Msg
getActivities user =
    case user of
            Nothing ->
                Http.get
                {
                    url = "http://localhost:5000/getActivities" ++ "?username=" ++ ""
                    , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
                }
            Just userA ->
                Http.get
                {
                    url = "http://localhost:5000/getActivities" ++ "?username=" ++ userA.username
                    , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
                }

getActivitiesA : String -> Cmd Msg
getActivitiesA username =
    Http.get
    {
        url = "http://localhost:5000/getActivities" ++ "?username=" ++ username
        , expect = Http.expectJson LoadActivities (Decode.list Activity.decodeActivity)
    }

getDoneA : Maybe User.Model -> Model -> Cmd Msg
getDoneA user model =
    case user of
            Nothing ->
                Http.get
                {
                    url = "http://localhost:5000/getDoneA" ++ "?username=" ++ ""
                    , expect = Http.expectJson LoadDoneA (Decode.list Activity.decodeActivity)
                }
            Just userA ->
                Http.get
                {
                    url = "http://localhost:5000/getDoneA" ++ "?username=" ++ userA.username ++ "&" ++ "date=" ++ ( Date.getDate model.day model.month model.year )
                    , expect = Http.expectJson LoadDoneA (Decode.list Activity.decodeActivity)
                }

getDoneAA : String -> Int -> Int -> Int -> Cmd Msg
getDoneAA username day month year =
    Http.get
        {
            url = "http://localhost:5000/getDoneA" ++ "?username=" ++ username ++ "&" ++ "date=" ++ ( Date.getDate day month year )
            , expect = Http.expectJson LoadDoneA (Decode.list Activity.decodeActivity)
        }

getDoneB : Maybe User.Model -> Model -> Cmd Msg
getDoneB user model =
    case user of
            Nothing ->
                Http.get
                {
                    url = "http://localhost:5000/getDoneA" ++ "?username=" ++ ""
                    , expect = Http.expectJson LoadDoneB (Decode.list Activity.decodeActivity)
                }
            Just userA ->
                Http.get
                {
                    url = "http://localhost:5000/getDoneA" ++ "?username=" ++ userA.username ++ "&" ++ "date=" ++ ( Date.getDateMinus model.day model.month model.year )
                    , expect = Http.expectJson LoadDoneB (Decode.list Activity.decodeActivity)
                }
    
getDoneBB : String -> Int -> Int -> Int -> Cmd Msg
getDoneBB username day month year =
    Http.get
        {
            url = "http://localhost:5000/getDoneA" ++ "?username=" ++ username ++ "&" ++ "date=" ++ ( Date.getDateMinus day month year )
            , expect = Http.expectJson LoadDoneB (Decode.list Activity.decodeActivity)
        }

---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "to_do_component" ]
    [
        div[ class "to_do" ]
        [
            a[ href "/todo", class "to_do_move", id "to_do_left", onClick ChangeMinus ][ text "<" ]
            , case model.usable of
                True ->
                    a[ href "/todo", class "to_do_move", id "to_do_right", onClick ChangePlus ][ text ">" ]
                False ->
                    a[ class "to_do_move to_do_unusable", id "to_do_right", onClick ChangePlus ][ text ">" ]
            
            , div[ class "to_do_body" ]
            [
                div[ class "to_do_day" ]
                [
                    h2[][ text ( Date.getDateMinus model.day model.month model.year ) ]
                    , div[ class "activities" ][
                        div[ class "done" ]( List.indexedMap (\index activity -> viewActivity index activity) (List.filter isNotActive model.done_left) )
                    ]
                ]
                , div[ id "today", class "to_do_day" ]
                [
                    h2[][ text ( Date.getDate model.day model.month model.year ) ]
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
                , a[ href "/todo", onClick AddActivity ][ text "Add activity" ]
                , case model.activity_warning of
                    1 ->
                        p[ class "to_do_warning" ][ text "Add activity name!" ]
                    _ ->
                        p[ class "to_do_warning" ][ text " " ]
            ]
        ]
    ]
    