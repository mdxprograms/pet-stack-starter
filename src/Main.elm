module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, p, text)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Random


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type GameState
    = Initializing
    | Playing Int Guess


type Guess
    = NotGuessed
    | Guessed Order
    | InvalidGuess


type alias Model =
    { guessInput : String, state : GameState }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { guessInput = "", state = Initializing }, generateSecretNumber )



-- UPDATE


type Msg
    = GeneratedNumber Int
    | GuessChange String
    | GuessSubmitted
    | Restart


generateSecretNumber : Cmd Msg
generateSecretNumber =
    Random.generate GeneratedNumber (Random.int 0 100)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GeneratedNumber num ->
            ( { model | state = Playing num NotGuessed }, Cmd.none )

        GuessChange str ->
            ( { model | guessInput = str }, Cmd.none )

        GuessSubmitted ->
            case model.state of
                Playing secretNumber guess ->
                    let
                        newGuess =
                            case String.toInt model.guessInput of
                                Just num ->
                                    Guessed (compare num secretNumber)

                                Nothing ->
                                    InvalidGuess
                    in
                    ( { model | state = Playing secretNumber newGuess }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Restart ->
            ( { model | state = Initializing }, generateSecretNumber )



-- VIEW


viewGuessInput : Html Msg
viewGuessInput =
    div []
        [ p [] [ text "What's your guess?" ]
        , input [ type_ "text", onInput GuessChange
        , class "w-full p-2 border border-green-400 hover:border-green-600 focus:border-green-600 md:flex-1"
        , class "text-center rounded shadow focus:outline-none focus:shadow-outline"
        ]
        []
        , button [ type_ "button", onClick GuessSubmitted ]
            [ text "Submit"
            ]
        ]


viewResult : Order -> Html Msg
viewResult order =
    case order of
        LT ->
            div []
                [ p [] [ text "Too Small" ]
                , viewGuessInput
                ]

        GT ->
            div []
                [ p [] [ text "Too Big" ]
                , viewGuessInput
                ]

        EQ ->
            div []
                [ p [] [ text "Correct" ]
                , button
                    [ type_ "button"
                    , onClick Restart
                    ]
                    [ text "start over" ]
                ]


view : Model -> Browser.Document Msg
view model =
    { title = "PET Stack Guessing Game"
    , body =
        [ div []
            [ h1 [] [ text "PET Stack Guessing Game" ]
            , div []
                [ case model.state of
                    Initializing ->
                        text "Generating Number"

                    Playing num guess ->
                        case guess of
                            NotGuessed ->
                                viewGuessInput

                            Guessed difference ->
                                viewResult difference

                            InvalidGuess ->
                                div []
                                    [ p [] [ text "You didn't enter a valid number" ]
                                    , viewGuessInput
                                    ]
                ]
            ]
        ]
    }
