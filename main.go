package main

import (
	"bufio"
	"fmt"
	"os"
	"pira/dnsleak/internal/api"
	"pira/dnsleak/internal/ui"
	"strings"
)

func main() {
	for {
		err := runDNSTest()
		if err != nil {
			// Handle error case
			display := ui.NewDisplay()
			display.PrintError(err)
			
			// Prompt user for retry or quit after error
			fmt.Print("\nPress 'q' to quit or any other key to retry: ")
			reader := bufio.NewReader(os.Stdin)
			input, _ := reader.ReadString('\n')
			input = strings.TrimSpace(input) // Trim whitespace and newlines
			
			if len(input) > 0 && (input[0] == 'q' || input[0] == 'Q') {
				break
			}
			// If any other key, continue the loop to retry
			continue
		}
		
		// Prompt user for retry or quit after successful completion
		fmt.Print("\nPress 'q' to quit or any other key to retry: ")
		reader := bufio.NewReader(os.Stdin)
		input, _ := reader.ReadString('\n')
		input = strings.TrimSpace(input) // Trim whitespace and newlines
		
		if len(input) > 0 && (input[0] == 'q' || input[0] == 'Q') {
			break
		}
		// If any other key, continue the loop to retry
	}
}

func runDNSTest() error {
	// Create API client and UI display
	client := api.NewClient()
	display := ui.NewDisplay()

	// Display title
	display.PrintTitle("DNS Leak Test")
	display.PrintSeparator()

	// Get test ID
	testID, err := client.GetTestID()
	if err != nil {
		return err
	}

	// Perform fake pings
	display.PrintTitle("Testing DNS leak...")
	client.PerformFakePings(testID)

	// Get results
	results, err := client.GetResults(testID)
	if err != nil {
		return err
	}

	// Display results
	display.PrintIPSection(results)
	display.PrintDNSSection(results)
	display.PrintConclusionSection(results)
	
	return nil // Success
}