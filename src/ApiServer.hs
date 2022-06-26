{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds, MultiParamTypeClasses #-}
--enabling language extension overloaded string so that we dont have to convert an actual string to text type
module ApiServer (apiServer) where

--importing lazy version of text data type here
import Data.Text.Lazy (Text)
import Data.Text.Lazy.Encoding (encodeUtf8)
import Network.HTTP.Media ((//),(/:))
import Network.Wai.Handler.Warp (run)
import Servant

-- eg http://mydomain.com

data HTML

-- // and /: this operator is coming from network media 
instance Accept HTML where
    contentType _ = "text" // "html" /: ("charset", "utf-8")


instance MimeRender HTML Text where
    mimeRender _ = encodeUtf8

--defination of API that handles main route/domain
type ServerAPI =
    Get '[HTML] Text

--implementation of API defined above
serverRoutes :: Server ServerAPI
serverRoutes = return "Hello from Satyam ! This is my first Haskell Server finally !!"

--define proxy for use of certain functions and abstraction over API
serverProxy :: Proxy ServerAPI
serverProxy = Proxy

--define WAI application that will serve with serverProxy or serverRoutes
router :: Application
router = serve serverProxy serverRoutes

apiServer :: IO ()
--apiServer = putStrLn "I'm a little server! (not)"
apiServer = run 80 router
