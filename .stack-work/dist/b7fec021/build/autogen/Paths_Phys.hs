{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_Phys (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Tristan Thompson\\Desktop\\Haskell\\LearnHaskell-Phys\\.stack-work\\install\\3122d1ef\\bin"
libdir     = "C:\\Users\\Tristan Thompson\\Desktop\\Haskell\\LearnHaskell-Phys\\.stack-work\\install\\3122d1ef\\lib\\x86_64-windows-ghc-8.0.1\\Phys-0.1.0.0-FqDVBlAaeX0HfAo5eLgQw"
datadir    = "C:\\Users\\Tristan Thompson\\Desktop\\Haskell\\LearnHaskell-Phys\\.stack-work\\install\\3122d1ef\\share\\x86_64-windows-ghc-8.0.1\\Phys-0.1.0.0"
libexecdir = "C:\\Users\\Tristan Thompson\\Desktop\\Haskell\\LearnHaskell-Phys\\.stack-work\\install\\3122d1ef\\libexec"
sysconfdir = "C:\\Users\\Tristan Thompson\\Desktop\\Haskell\\LearnHaskell-Phys\\.stack-work\\install\\3122d1ef\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Phys_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Phys_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Phys_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Phys_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Phys_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
