module Main where

import MyLib (someFunc)
import Main.Utf8 (withUtf8)

main :: IO ()
main = withUtf8 do
  putStrLn "Hello, Haskell!"
  someFunc
