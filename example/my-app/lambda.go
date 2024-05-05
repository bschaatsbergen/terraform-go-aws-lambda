package main

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, event interface{}) (string, error) {
	return "Hello Mars", nil
}

func main() {
	lambda.Start(HandleRequest)
}
