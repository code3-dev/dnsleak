package main

import (
	"bufio"
	"fmt"
	"os"
	"pira/dnsleak/internal/api"
	"pira/dnsleak/internal/ui"
)

func main() {
	for {
		err := runDNSTest()
		if err != nil {
			// Handle error case
			display := ui.NewDisplay()
			display.PrintError(err)
			
			// Prompt user for retry or quit after error
			fmt.Print("\nError occurred. Press 'r' to retry or 'q' to quit: ")
			reader := bufio.NewReader(os.Stdin)
			input, _ := reader.ReadString('\n')
			
			if input[0] == 'q' || input[0] == 'Q' {
				break
			}
			// If 'r' or anything else, continue the loop to retry
			continue
		}
		
		// Prompt user for retry or quit after successful completion
		fmt.Print("\nTask completed. Press 'r' to retry or 'q' to quit: ")
		reader := bufio.NewReader(os.Stdin)
		input, _ := reader.ReadString('\n')
		
		if input[0] == 'q' || input[0] == 'Q' {
			break
		}
		// If 'r' or anything else, continue the loop to retry
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