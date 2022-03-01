module Components.LogIn.Signup_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Components.User.User as User exposing (..)
import Components.LogIn.Signup_model as Signup_model exposing (..)


init : ( Signup_model.Model, Cmd Msg )
init = ( Signup_model.Model "" "" "" "" 0 Empty , Cmd.none)



---- UPDATE ----


type Msg
    = NoOp
    | UserName String
    | Email String
    | Password String
    | RePassword String
    | Submit
    | Response (Result Http.Error User.Model)

update : Msg -> Signup_model.Model -> ( Signup_model.Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UserName username ->
            ( { model | username = username }, Cmd.none )
                
        Email email ->
            ( { model | email = email }, Cmd.none )

        Password password ->
            ( { model | password = password }, Cmd.none )
        RePassword repassword ->
            ( { model | repassword = repassword }, Cmd.none )

        Submit ->
            if model.username == "" || zeroString model.username then
                ( { model | warning = 1 }, Cmd.none )
            else if not(lenString model.username) then
                ( { model | warning = 2 }, Cmd.none )
            else if model.email == "" || zeroString model.email then
                ( { model | warning = 3 }, Cmd.none )
            else if model.password == "" || zeroString model.password then
                ( { model | warning = 4 }, Cmd.none )
            else if not(lenString model.password) then
                ( { model | warning = 5 }, Cmd.none )
            else if model.repassword == "" || zeroString model.repassword then
                ( { model | warning = 6 }, Cmd.none )
            else if not(checkPassword model.password model.repassword) then
                ( { model | warning = 7 }, Cmd.none )
            else
                ( { model | warning = 0, status = Empty }, login model )

        Response response ->
            case response of
                Ok user ->
                    ( { model | status = Success "" }, Cmd.none )
                Err log ->
                    ( { model | status = Signup_model.Failure log }, Cmd.none )


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

checkPassword : String -> String -> Bool
checkPassword password repassword =
    if password /= repassword then
        False
    else
        True

encodeLogin : Signup_model.Model -> Encode.Value
encodeLogin model =
    Encode.object[
        ("username", Encode.string model.username)
        , ("mail", Encode.string model.email)
        , ("password", Encode.string model.password)
    ]

login : Signup_model.Model -> Cmd Msg
login model =
    Http.post
    {
        url = "http://localhost:5000/register"
        , body = Http.jsonBody <| encodeLogin model
        , expect = Http.expectJson Response User.decodeUser
    }

getModel : ( Signup_model.Model, Cmd Msg ) -> Signup_model.Model
getModel ( model, cmd ) =
    model