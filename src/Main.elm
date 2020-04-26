module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, p, text)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)


type Guess
    = NotGuessed
    | Guessed Int
    | InvalidGuess


type GameState
    = Initializing
    | Playing Int Guess


type alias Model =
    { guessInput : String, state : GameState }


main : Program flags a msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


init =
    Debug.todo "Implement init"


update =
    Debug.todo "Implement update"


view =
    Debug.todo "Implement view"
