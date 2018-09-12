module Main exposing (main)

--import Browser
--import Css exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type Blog
    = Blog String
    
type MaybeSaved doc
    = MaybeSaved doc doc

type alias Model =
        { blog : MaybeSaved Blog }

currentBlog : MaybeSaved Blog -> Blog
currentBlog (MaybeSaved _ new) =
    new

lastSavedBlog : MaybeSaved Blog -> Blog
lastSavedBlog (MaybeSaved old _) =
    old
    
readNewBlogText : MaybeSaved Blog -> String
readNewBlogText (MaybeSaved _ new) =
    extractBlogText new
    

readLastSavedBlogText : MaybeSaved Blog -> String
readLastSavedBlogText (MaybeSaved old _) =
    extractBlogText old

extractBlogText : Blog -> String
extractBlogText (Blog blogText) =
    blogText

--change : (Int -> doc) -> MaybeSaved doc -> Int -> MaybeSaved doc
--change changeFn (MaybeSaved lastSaved current) i =
--    MaybeSaved lastSaved (changeFn i)

--change : (doc -> doc) -> MaybeSaved doc -> MaybeSaved doc
--change changeFn (MaybeSaved lastSaved current) =
--    MaybeSaved lastSaved (changeFn current)

buildUpdatedBlog : doc -> MaybeSaved doc -> MaybeSaved doc
buildUpdatedBlog newBlog (MaybeSaved lastSaved current) =
    MaybeSaved lastSaved newBlog


setSaved : doc -> MaybeSaved doc -> MaybeSaved doc
setSaved savedBlobText (MaybeSaved lastSaved current) =
    MaybeSaved savedBlobText current
 
hasNoChangesToSave : MaybeSaved doc -> Bool
hasNoChangesToSave (MaybeSaved lastSaved current) =
    lastSaved ==  current
    
initialModel : (Model, Cmd Msg)
initialModel =
   ( { 
        --blog = change (\_ -> Blog "newblogtxt")  (MaybeSaved (Blog "next txt") (Blog "next txt"))
        blog = MaybeSaved (Blog "") (Blog "")
    }, Cmd.none )

type Msg
    = MakeChange Blog
    | Save


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
       
        --MakeChange newBlogText ->
        MakeChange newBlog ->
            --{ model | blog = change (\_ -> Blog newBlogText) model.blog 10, hasSaved = True }
            --{ model | blog = change (\_ -> Blog newBlogText) model.blog, hasSaved = True }
           ({ model | blog = buildUpdatedBlog newBlog model.blog }, Cmd.none)
            --{ model | blog = MaybeSaved (lastSavedBlog model.blog) newBlog }
        Save ->
            
                --let 
                  --  savedBlob = setSaved (currentBlog model.blog) model.blog
            
                --in
                  -- {model | blog = savedBlob}
                
                -- Imagine saving is done successfully using an API
               ( {model | blog = setSaved (currentBlog model.blog) model.blog}, Cmd.none )
                
            
view : Model -> Html Msg
view model =
    div []
        [  
         --textarea [ onInput (MakeChange << Blog), value  (readNewBlogText model.blog)] [] 
         textarea [onInput (\newContents -> MakeChange (Blog newContents)), value (readNewBlogText model.blog)] [] 
         ,div [] [text ("New blog text : " ++ (readNewBlogText model.blog))]
         ,br[][]
         ,div [] [text ("Last Saved blog text : " ++ (readLastSavedBlogText model.blog))]
         ,br[][]
         ,button [ onClick Save, disabled (hasNoChangesToSave model.blog) ] [ text "Save..."  ]
        ]

subscriptions model =
    Sub.none

main : Program Never Model Msg
main =
   program
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
