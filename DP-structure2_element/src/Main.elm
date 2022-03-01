port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
{- import Components.Footer.Footer as Footer exposing (..) -}
import Components.Footer.Footer_model as Footer_model exposing (..)
import Components.Footer.Footer_update as Footer_update exposing (..)
import Components.Footer.Footer_view as Footer_view exposing (..)
{- import Components.Header.Header as Header exposing (..) -}
import Components.Header.Header_model as Header_model exposing (..)
import Components.Header.Header_update as Header_update exposing (..)
import Components.Header.Header_view as Header_view exposing (..)
{- import Components.LogIn.Login as Login exposing (..) -}
import Components.LogIn.Login_model as Login_model exposing (..)
import Components.LogIn.Login_update as Login_update exposing (..)
import Components.LogIn.Login_view as Login_view exposing (..)
{- import Components.LogIn.Signup as Signup exposing (..) -}
import Components.LogIn.Signup_model as Signup_model exposing (..)
import Components.LogIn.Signup_update as Signup_update exposing (..)
import Components.LogIn.Signup_view as Signup_view exposing (..)
{- import Components.Login.Signedup as Signedup exposing (..) -}
import Components.Login.Signedup_model as Signedup_model exposing (..)
import Components.Login.Signedup_update as Signedup_update exposing (..)
import Components.Login.Signedup_view as Signedup_view exposing (..)
{- import Components.Login.Access as Access exposing (..) -}
import Components.Login.Access_model as Access_model exposing (..)
import Components.Login.Access_update as Access_update exposing (..)
import Components.Login.Access_view as Access_view exposing (..)
{- import Components.Home.Home as Home exposing (..) -}
import Components.Home.Home_model as Home_model exposing (..)
import Components.Home.Home_update as Home_update exposing (..)
import Components.Home.Home_view as Home_view exposing (..)
{- import Components.Button.Button as Button exposing (..) -}
import Components.Button.Button_model as Button_model exposing (..)
import Components.Button.Button_update as Button_update exposing (..)
import Components.Button.Button_view as Button_view exposing (..)
{- import Components.ToDo.ToDo as ToDo exposing (..) -}
import Components.ToDo.ToDo_model as ToDo_model exposing (..)
import Components.ToDo.ToDo_update as ToDo_update exposing (..)
import Components.ToDo.ToDo_view as ToDo_view exposing (..)
{- import Components.ToDo.Activity as Activity exposing (..) -}
import Components.User.User as User exposing (..)
{- import Components.Date.Date as Date exposing (..) -}
import Components.Date.Date_model as Date_model exposing (..)
import Components.Date.Date_update as Date_update exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode


---- MODEL ----


type alias Model =
    {
        page : Page
        , header : Header_model.Model
        , home : Home_model.Model
        , footer : Footer_model.Model
        , signup : Signup_model.Model
        , signedup : Signedup_model.Model
        , access : Access_model.Model
        , login : Login_model.Model
        , storage : Button_model.Model
        , todo : ToDo_model.Model
        , button : Button_model.Model
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
                , header = Header_model.init
                , home = Home_model.init
                , footer = Footer_model.init
                , signup = Signup_update.getModel Signup_update.init
                , signedup = Signedup_model.init
                , access= Access_model.init
                , login = Login_update.getModel Login_update.init
                , storage = Button_model.init
                , todo = ToDo_update.getModel (ToDo_update.init Nothing)
                , button = Button_model.init
                , user = Nothing }, Cmd.none )
        Just token ->
            ({ page = Home
                , header = Header_model.init
                , home = Home_model.init
                , footer = Footer_model.init
                , signup = Signup_update.getModel Signup_update.init
                , signedup = Signedup_model.init
                , access= Access_model.init
                , login = Login_update.getModel Login_update.init
                , storage = Button_model.init
                , todo = ToDo_update.getModel (ToDo_update.init Nothing)
                , button = Button_model.init
                , user = Nothing }, loadUser token )



---- UPDATE ----


type Msg
    = NoOp
    | Header_msg Header_update.Msg
    | Home_msg Home_update.Msg
    | Footer_msg Footer_update.Msg
    | Signup_msg Signup_update.Msg
    | Login_msg Login_update.Msg
    | Button_msg Button_update.Msg
    | ToDo_msg ToDo_update.Msg
    | Signedup_msg Signedup_update.Msg
    | Access_msg Access_update.Msg
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
                        Header_model.Login -> 
                            ({ model | header = Header_update.update childMsg model.header, login = Login_update.getModel Login_update.init, page = Login }, Cmd.none)
                        Header_model.Signup -> 
                            ({ model | header = Header_update.update childMsg model.header, signup = Signup_update.getModel Signup_update.init, page = Signup }, Cmd.none)
                Logout -> ({ model | header = Header_update.update childMsg model.header, page = Home, user = Nothing }, logoutStore)
                _ -> ( model, Cmd.none )
        Home_msg childMsg ->
            ({ model | home = Home_update.update childMsg model.home }, Cmd.none)
        Footer_msg childMsg ->
            case childMsg of
                FooterSwapPage page ->
                    case page of
                        Footer_model.Home -> 
                            ({ model | footer = Footer_update.update childMsg model.footer, page = Home }, Cmd.none)
                        Footer_model.ToDo ->
                               ({ model | footer = Footer_update.update childMsg model.footer, todo = ToDo_update.getModel ( ToDo_update.init model.user ), page = ToDo }, Cmd.map ToDo_msg ( Cmd.batch [ ToDo_update.getTime, ToDo_update.getActivities model.user ]))
                        Footer_model.Ritual ->
                            ({ model | footer = Footer_update.update childMsg model.footer, page = Ritual }, Cmd.none)
                _ -> ( model, Cmd.none )
        Signup_msg childMsg ->
            case childMsg of
                Signup_update.Response response ->
                    case response of
                        Ok user ->
                            ({ model | page = Signedup }, Cmd.none )
                        _ ->
                            signupF model ( Signup_update.update childMsg model.signup )
                _ ->
                    signupF model ( Signup_update.update childMsg model.signup ) 
        Login_msg childMsg ->
            case childMsg of
                Login_update.Response response ->
                    case response of
                        Ok user ->
                            case model.button.storage of
                                Cookies ->
                                    ({ model | page = Home, user = Just user, header = Header_update.changeLogged model.header }, prepareForCookiesUser (Just user.token) )
                                Local ->
                                    ({ model | page = Home, user = Just user, header = Header_update.changeLogged model.header }, prepareForLocalUser (Just user.token) )
                                Session ->
                                    ({ model | page = Home, user = Just user, header = Header_update.changeLogged model.header }, prepareForSessionUser (Just user.token) )
                        _ ->
                            loginF model ( Login_update.update childMsg model.login )
                _ ->
                    loginF model ( Login_update.update childMsg model.login )
        Button_msg childMsg ->
            case childMsg of
                SwapStorage storage ->
                    case storage of
                        Cookies ->
                            ({ model | storage = Button_update.update childMsg model.storage }, prepareForCookies model )
                        Local ->
                            ({ model | storage = Button_update.update childMsg model.storage }, prepareForLocal model )
                        Session ->
                            ({ model | storage = Button_update.update childMsg model.storage }, prepareForSession model )
                _ ->
                    ({ model | storage = Button_update.update childMsg model.storage }, Cmd.none )
        ToDo_msg childMsg ->
              case childMsg of
                ToDo_update.Response response ->
                    case response of
                        Ok activity ->
                            todoF model ( ToDo_update.update childMsg model.todo )
                        _ ->
                            todoF model ( ToDo_update.update childMsg model.todo )
                _ ->
                    todoF model ( ToDo_update.update childMsg model.todo )
        Signedup_msg childMsg ->
            case childMsg of
                TryLog ->
                    ({ model | signedup = Signedup_update.update childMsg model.signedup,  signup = Signup_update.getModel Signup_update.init, page = Login }, Cmd.none)
                _ ->
                    ({ model | signedup = Signedup_update.update childMsg model.signedup }, Cmd.none)
        Access_msg childMsg ->
            case childMsg of
                Log ->
                    ({ model | access = Access_update.update childMsg model.access, login = Login_update.getModel Login_update.init, page = Login }, Cmd.none)
                Sig ->
                    ({ model | access = Access_update.update childMsg model.access,  signup = Signup_update.getModel Signup_update.init, page = Signup }, Cmd.none)
                _ -> 
                    ({ model | access = Access_update.update childMsg model.access }, Cmd.none)
        LoadUser response ->
            case response of
                Ok user ->
                    ( { model | user = Just user, header = Header_update.changeLogged model.header }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )


signupF : Model -> ( Signup_model.Model, Cmd Signup_update.Msg ) -> ( Model, Cmd Msg )
signupF model ( signup, cmd ) =
    ( { model | signup = signup }, Cmd.map Signup_msg cmd )

loginF : Model -> ( Login_model.Model, Cmd Login_update.Msg ) -> ( Model, Cmd Msg )
loginF model ( login, cmd ) =
    ( { model | login = login }, Cmd.map Login_msg cmd )

todoF : Model -> ( ToDo_model.Model, Cmd ToDo_update.Msg ) -> ( Model, Cmd Msg )
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
            Home_update.subscriptions Home_model.init |> Sub.map Home_msg
        _ -> 
            Sub.none


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [
        Button_view.view model.storage |> Html.map Button_msg
        , Header_view.view model.header |> Html.map Header_msg
        , case model.page of
            Login -> Login_view.view model.login |> Html.map Login_msg
            Signup -> Signup_view.view model.signup |> Html.map Signup_msg
            ToDo -> 
                case model.user of
                    Nothing ->
                        Access_view.view model.access |> Html.map Access_msg
                    _ ->
                        ToDo_view.view model.todo |> Html.map ToDo_msg
            Ritual -> Access_view.view model.access |> Html.map Access_msg
            Signedup -> Signedup_view.view model.signedup |> Html.map Signedup_msg
            _ -> Home_view.view model.home |> Html.map Home_msg
        , Footer_view.view model.footer |> Html.map Footer_msg
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

