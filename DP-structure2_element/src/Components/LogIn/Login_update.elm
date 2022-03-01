module Components.LogIn.Login_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.User.User as User exposing (..)
import Components.LogIn.Login_model as Login_model exposing (..)


init : ( Login_model.Model, Cmd Msg )
init = ( Login_model.Model "" "" 0 Empty , Cmd.none )


---- UPDATE ----


type Msg
    = NoOp
    | UserName String
    | Password String
    | Submit
    | Response (Result Http.Error User.Model)


update : Msg -> Login_model.Model -> ( Login_model.Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UserName username ->
            ( { model | username = username }, Cmd.none )

        Password password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            if model.username == "" || zeroString model.username then
                ( { model | warning = 1 }, Cmd.none )
            else if not(lenString model.username) then
                ( { model | warning = 2 }, Cmd.none )
            else if model.password == "" || zeroString model.password then
                ( { model | warning = 4 }, Cmd.none )
            else if not(lenString model.password) then
                ( { model | warning = 5 }, Cmd.none )
            else
                ( { model | warning = 0 }, signup model )

        Response response ->
            case response of
                Ok user ->
                    ( { model | status = Success "" }, Cmd.none )
                Err log ->
                    ( { model | status = Login_model.Failure log }, Cmd.none )


zeroString : String -> Bool
zeroString word =
    if String.length word == 0 then
        True
    else
        False

lenString : String -> Bool
lenString word =
    if String.length word > 6 then
        True
    else
        False

encodeSignup : Login_model.Model -> Encode.Value
encodeSignup model =
    Encode.object[
        ("username", Encode.string model.username)
        , ("password", Encode.string model.password)
    ]

signup : Login_model.Model -> Cmd Msg
signup model =
    Http.post
    {
        url = "http://localhost:5000/login"
        , body = Http.jsonBody <| encodeSignup model
        , expect = Http.expectJson Response User.decodeUser
    }

getModel : ( Login_model.Model, Cmd Msg ) -> Login_model.Model
getModel ( model, cmd ) =
    model