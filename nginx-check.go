package main

import (
        "fmt"
        "os/exec"
)

func main() {
        cmd := exec.Command("systemctl", "status", "nginx")
        cmd_heal := exec.Command("systemctl", "restart", "nginx")
        err := cmd.Run()
        heal := cmd_heal.Run()
        if err != nil {
                fmt.Printf("%v\n", err)
                fmt.Printf("%v\n", heal)
        }
}
