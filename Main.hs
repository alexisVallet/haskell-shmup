module Main where

import Graphics.UI.SDL
import Control.Monad
import Control.Lens
import Control.Monad.Trans.Class
import Control.Monad.IO.Class
import Control.Monad.State.Class

import Rendering
import Environment
import Ship
import Config

main :: IO ()
main = withInit [InitEverything] $ do
  screen <- setVideoMode screenWidth screenHeight 32 [SWSurface]
  runMain $ do
    loadShipAssets
    ship <- runGame $ newShip screenCenter
    addAgent ship
    forever $ do
      start <- liftIO getTicks
      runGame $ updateEnvironment frameSeconds
      environment' <- use environment
      liftIO $ do
        renderEnvironment screen environment'
        end <- getTicks
        when (end - start < frameTicks) $ delay $ frameTicks - (end - start)
