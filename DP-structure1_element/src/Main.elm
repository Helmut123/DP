port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Components.Footer.Footer as Footer exposing (..)
import Components.Header.Header as Header exposing (..)
import Components.LogIn.Login as Login exposing (..)
import Components.LogIn.Signup as Signup exposing (..)
import Components.Login.Signedup as Signedup exposing (..)
import Components.Login.Access as Access exposing (..)
import Components.Home.Home as Home exposing (..)
import Components.Button.Button as Button exposing (..)
import Components.ToDo.ToDo as ToDo exposing (..)
import Components.ToDo.Activity as Activity exposing (..)
import Components.User.User as User exposing (..)
import Components.Date.Date as Date exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode


---- MODEL ----


type alias Model =
    {
        page : Page
        , header : Header.Model
        , home : Home.Model
        , footer : Footer.Model
        , signup : Signup.Model
        , signedup : Signedup.Model
        , access : Access.Model
        , login : Login.Model
        , storage : Button.Model
        , todo : ToDo.Model
        , button : Button.Model
        , user : Maybe User.Model
    }

type Page = Home
    | Signup
    | Login
    | ToDo
    | Signedup
    | Access
    | Ritual


init : Maybe String -> ( Model, Cmd Msg )
init flag =
    case flag of
        Nothing ->
            ({ page = Home
                , header = Header.init
                , home = Home.init
                , footer = Footer.init
                , signup = Signup.getModel Signup.init
                , signedup = Signedup.init
                , access= Access.init
                , login = Login.getModel Login.init
                , storage = Button.init
                , todo = ToDo.getModel (ToDo.init Nothing)
                , button = Button.init
                , user = Nothing }, Cmd.none )
        Just token ->
            ({ page = Home
                , header = Header.init
                , home = Home.init
                , footer = Footer.init
                , signup = Signup.getModel Signup.init
                , signedup = Signedup.init
                , access= Access.init
                , login = Login.getModel Login.init
                , storage = Button.init
                , todo = ToDo.getModel (ToDo.init Nothing)
                , button = Button.init
                , user = Nothing }, loadUser token )



---- UPDATE ----


type Msg
    = NoOp
    | Header_msg Header.Msg
    | Home_msg Home.Msg
    | Footer_msg Footer.Msg
    | Signup_msg Signup.Msg
    | Login_msg Login.Msg
    | Button_msg Button.Msg
    | ToDo_msg ToDo.Msg
    | Signedup_msg Signedup.Msg
    | Access_msg Access.Msg
    | LoadUser (Result Http.Error User.Model)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> 
            ( model, Cmd.none )
        Header_msg childMsg ->
            case childMsg of
                SwapPage page ->
                    case page of
                        Header.Login -> 
                            ({ model | header = Header.update childMsg model.header, login = Login.getModel Login.init, page = Login }, Cmd.none)
                        Header.Signup -> 
                            ({ model | header = Header.update childMsg model.header, signup = Signup.getModel Signup.init, page = Signup }, Cmd.none)
                Logout -> ({ model | header = Header.update childMsg model.header, page = Home, user = Nothing }, logoutStore)
                _ -> ( model, Cmd.none )
        Home_msg childMsg ->
            ({ model | home = Home.update childMsg model.home }, Cmd.none)
        Footer_msg childMsg ->
            case childMsg of
                FooterSwapPage page ->
                    case page of
                        Footer.Home -> 
                            ({ model | footer = Footer.update childMsg model.footer, page = Home }, Cmd.none)
                        Footer.ToDo ->
                               ({ model | footer = Footer.update childMsg model.footer, todo = ToDo.getModel ( ToDo.init model.user ), page = ToDo }, Cmd.map ToDo_msg ( Cmd.batch [ ToDo.getTime, ToDo.getActivities model.user ]))
                        Footer.Ritual ->
                            ({ model | footer = Footer.update childMsg model.footer, page = Ritual }, Cmd.none)
                _ -> ( model, Cmd.none )
        Signup_msg childMsg ->
            case childMsg of
                Signup.Response response ->
                    case response of
                        Ok user ->
                            ({ model | page = Signedup }, Cmd.none )
                        _ ->
                            signupF model ( Signup.update childMsg model.signup )
                _ ->
                    signupF model ( Signup.update childMsg model.signup ) 
        Login_msg childMsg ->
            case childMsg of
                Login.Response response ->
                    case response of
                        Ok user ->
                            case model.button.storage of
                                Cookies ->
                                    ({ model | page = Home, user = Just user, header = Header.changeLogged model.header }, prepareForCookiesUser (Just user.token) )
                                Local ->
                                    ({ model | page = Home, user = Just user, header = Header.changeLogged model.header }, prepareForLocalUser (Just user.token) )
                                Session ->
                                    ({ model | page = Home, user = Just user, header = Header.changeLogged model.header }, prepareForSessionUser (Just user.token) )
                        _ ->
                            loginF model ( Login.update childMsg model.login )
                _ ->
                    loginF model ( Login.update childMsg model.login )
        Button_msg childMsg ->
            case childMsg of
                SwapStorage storage ->
                    case storage of
                        Cookies ->
                            ({ model | storage = Button.update childMsg model.storage }, prepareForCookies model )
                        Local ->
                            ({ model | storage = Button.update childMsg model.storage }, prepareForLocal model )
                        Session ->
                            ({ model | storage = Button.update childMsg model.storage }, prepareForSession model )
                _ ->
                    ({ model | storage = Button.update childMsg model.storage }, Cmd.none )
        ToDo_msg childMsg ->
              case childMsg of
                ToDo.Response response ->
                    case response of
                        Ok activity ->
                            todoF model ( ToDo.update childMsg model.todo )
                        _ ->
                            todoF model ( ToDo.update childMsg model.todo )
                _ ->
                    todoF model ( ToDo.update childMsg model.todo )
        Signedup_msg childMsg ->
            case childMsg of
                TryLog ->
                    ({ model | signedup = Signedup.update childMsg model.signedup,  signup = Signup.getModel Signup.init, page = Login }, Cmd.none)
                _ ->
                    ({ model | signedup = Signedup.update childMsg model.signedup }, Cmd.none)
        Access_msg childMsg ->
            case childMsg of
                Log ->
                    ({ model | access = Access.update childMsg model.access, login = Login.getModel Login.init, page = Login }, Cmd.none)
                Sig ->
                    ({ model | access = Access.update childMsg model.access,  signup = Signup.getModel Signup.init, page = Signup }, Cmd.none)
                _ -> 
                    ({ model | access = Access.update childMsg model.access }, Cmd.none)
        LoadUser response ->
            case response of
                Ok user ->
                    ( { model | user = Just user, header = Header.changeLogged model.header }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )


signupF : Model -> ( Signup.Model, Cmd Signup.Msg ) -> ( Model, Cmd Msg )
signupF model ( signup, cmd ) =
    ( { model | signup = signup }, Cmd.map Signup_msg cmd )

loginF : Model -> ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
loginF model ( login, cmd ) =
    ( { model | login = login }, Cmd.map Login_msg cmd )

todoF : Model -> ( ToDo.Model, Cmd ToDo.Msg ) -> ( Model, Cmd Msg )
todoF model ( todo, cmd ) =
    ( { model | todo = todo }, Cmd.map ToDo_msg cmd )

encodeLoadUser : String -> Encode.Value
encodeLoadUser token =
    Encode.object[
        ("token", Encode.string token)
    ]

loadUser : String -> Cmd Msg
loadUser token =
    Http.post
    {
        url = "http://localhost:5000/loadUser"
        , body = Http.jsonBody <| encodeLoadUser token
        , expect = Http.expectJson LoadUser User.decodeUser
    }

---- SUBSCRIPTIONS ----

subscriptions: Model -> Sub Msg
subscriptions model =
    case model.page of
        Home -> 
            Home.subscriptions Home.init |> Sub.map Home_msg
        _ -> 
            Sub.none


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [
        Button.view model.storage |> Html.map Button_msg
        , Header.view model.header |> Html.map Header_msg
        , case model.page of
            Login -> Login.view model.login |> Html.map Login_msg
            Signup -> Signup.view model.signup |> Html.map Signup_msg
            ToDo -> 
                case model.user of
                    Nothing ->
                        Access.view model.access |> Html.map Access_msg
                    _ ->
                        ToDo.view model.todo |> Html.map ToDo_msg
            Ritual -> Access.view model.access |> Html.map Access_msg
            Signedup -> Signedup.view model.signedup |> Html.map Signedup_msg
            _ -> Home.view model.home |> Html.map Home_msg
        , Footer.view model.footer |> Html.map Footer_msg
        ]



---- PROGRAM ----


main : Program (Maybe String) Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


---- PORTS ----

port storeLocal : Maybe String -> Cmd msg

prepareForLocal : Model -> Cmd msg
prepareForLocal model =
    case model.user of
        Nothing ->
            storeLocal Nothing
        Just user ->
            storeLocal ( Just user.token )

prepareForLocalUser : Maybe String -> Cmd msg
prepareForLocalUser token =
    case token of
        Nothing ->
            storeLocal Nothing
        Just string ->
            storeLocal ( Just string )

port storeSession : Maybe String -> Cmd msg

prepareForSession : Model -> Cmd msg
prepareForSession model =
    case model.user of
        Nothing ->
            storeSession Nothing
        Just user ->
            storeSession ( Just user.token )

prepareForSessionUser : Maybe String -> Cmd msg
prepareForSessionUser token =
    case token of
        Nothing ->
            storeSession Nothing
        Just string ->
            storeSession ( Just string )

port storeCookies : Maybe String -> Cmd msg

prepareForCookies : Model -> Cmd msg
prepareForCookies model =
    case model.user of
        Nothing ->
            storeCookies Nothing
        Just user ->
            storeCookies ( Just user.token )

prepareForCookiesUser : Maybe String -> Cmd msg
prepareForCookiesUser token =
    case token of
        Nothing ->
            storeCookies Nothing
        Just string ->
            storeCookies ( Just string )

logoutStore : Cmd msg
logoutStore =
    Cmd.batch [ storeLocal Nothing ] --, storeSession Nothing, storeCookies Nothing

