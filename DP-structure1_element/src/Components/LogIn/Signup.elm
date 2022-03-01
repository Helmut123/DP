module Components.LogIn.Signup exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Components.User.User as User exposing (..)


---- MODEL ----


type alias Model =
    { username : String
    , password : String
    , repassword: String
    , email : String
    , warning : Int
    , status : Status
    }


init : ( Model, Cmd Msg )
init = ( Model "" "" "" "" 0 Empty , Cmd.none)



---- UPDATE ----


type Msg
    = NoOp
    | UserName String
    | Email String
    | Password String
    | RePassword String
    | Submit
    | Response (Result Http.Error User.Model)

type Status
    = Empty
    | Failure Http.Error
    | Success String

update : Msg -> Model -> ( Model, Cmd Msg )
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
                    ( { model | status = Failure log }, Cmd.none )


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

encodeLogin : Model -> Encode.Value
encodeLogin model =
    Encode.object[
        ("username", Encode.string model.username)
        , ("mail", Encode.string model.email)
        , ("password", Encode.string model.password)
    ]

login : Model -> Cmd Msg
login model =
    Http.post
    {
        url = "http://localhost:5000/register"
        , body = Http.jsonBody <| encodeLogin model
        , expect = Http.expectJson Response User.decodeUser
    }

getModel : ( Model, Cmd Msg ) -> Model
getModel ( model, cmd ) =
    model



---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "signup" ]
    [
        div[ class "signup_body" ]
        [
            div[ class "signup_form" ]
            [
                h2 [][ text "Sign Up" ]
                , div[ class "signup_inform" ]
                [
                    case model.warning of
                        1 -> div[ class "wrong_input" ]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        2 -> div[ class "wrong_input" ]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                    , case model.warning of
                        3 -> div[ class "wrong_input" ]
                            [
                                p[][ text "e-mail:" ]
                                , input[ placeholder "example@gmail.com",  type_ "email", Html.Attributes.value model.email, onInput Email ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "e-mail:" ]
                                , input[ placeholder "example@gmail.com",  type_ "email", Html.Attributes.value model.email, onInput Email ][]
                            ]
                    , case model.warning of 
                        4 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        5 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        7 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                    , case model.warning of
                        6 -> div[ class "wrong_input" ]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                        7 -> div[ class "wrong_input" ]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                ]
                , div[ class "signup_error" ]
                [
                    case model.warning of
                        1 -> p[][ text "ENTER username!" ]
                        2 -> p[][ text "Username too SHORT!" ]
                        3 -> p[][ text "ENTER e-mail!" ]
                        4 -> p[][ text "ENTER password!" ]
                        5 -> p[][ text "Password too SHORT!" ]
                        6 -> p[][ text "REENTER password!" ]
                        7 -> p[][ text "Passwords do NOT match!" ]
                        _ -> p[][ text "" ]
                ]
                , div[ class "button" ]
                [
                    if model.username == "" || model.password == "" || model.repassword == "" || model.email == "" then
                        a [ class "unclick", onClick Submit ][ text "Enter" ]
                    else
                        a [ onClick Submit ][ text "Enter" ]
                ]
            ]
        ]
    ]
    
    