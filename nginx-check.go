package main

import (
        "fmt"
        "os/exec"
)

func main() {
        cmd := exec.Command("systemctl", "status", "nginx")
        err := cmd.Run()
        if err != nil {
                fmt.Printf("%v\n", err)
        }
}
