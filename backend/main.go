package main

import (
    "log"
    "net/http"
    "github.com/Nickos0695/test/backend/api"
)

func main() {
    err := http.ListenAndServe(":5000", api.Handlers())

    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}