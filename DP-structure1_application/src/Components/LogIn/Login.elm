module Components.LogIn.Login exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_, href)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.User.User as User exposing (..)


---- MODEL ----


type alias Model =
    { username : String 
    , password : String
    , warning : Int
    , status : Status
    }



init : ( Model, Cmd Msg )
init = ( Model "" "" 0 Empty , Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | UserName String
    | Password String
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

encodeSignup : Model -> Encode.Value
encodeSignup model =
    Encode.object[
        ("username", Encode.string model.username)
        , ("password", Encode.string model.password)
    ]

signup : Model -> Cmd Msg
signup model =
    Http.post
    {
        url = "http://localhost:5000/login"
        , body = Http.jsonBody <| encodeSignup model
        , expect = Http.expectJson Response User.decodeUser
    }

getModel : ( Model, Cmd Msg ) -> Model
getModel ( model, cmd ) =
    model


---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "login" ]
    [
        div[ class "login_body" ]
        [
            div[ class "login_form" ]
            [
                h2 [][ text "Log In" ]
                , div[ class "login_inform" ]
                [
                    case model.warning of
                        1 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        2 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        _ -> div[]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                    
                    , case model.warning of
                        4 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        5 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        _ -> div[]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                ]
                , div[ class "signup_error" ]
                [
                    case model.warning of
                        1 -> p[][ text "ENTER username!" ]
                        2 -> p[][ text "INVALID username!" ]
                        4 -> p[][ text "ENTER password!" ]
                        5 -> p[][ text "INVALID password!" ]
                        _ -> p[][ text "" ]
                ]
                , div[ class "button" ]
                [
                    if model.username == "" || model.password == "" then
                        a [ class "unclick", onClick Submit ][ text "Enter" ]
                    else
                        a [ href "/", onClick Submit ][ text "Enter" ]
                ]
            ]
        ]
    ]
    