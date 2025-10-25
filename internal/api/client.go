package api

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"sync"
	"time"

	"pira/dnsleak/internal/model"
)

var (
	// APIDomain is the domain for the bash.ws API
	APIDomain = "bash.ws"

	// Timeout for HTTP requests
	Timeout = 10 * time.Second
)

// Client represents an API client for bash.ws
type Client struct {
	httpClient *http.Client
	apiDomain  string
}

// NewClient creates a new API client
func NewClient() *Client {
	return &Client{
		httpClient: &http.Client{
			Timeout: Timeout,
		},
		apiDomain: APIDomain,
	}
}

// GetTestID retrieves a test ID from the API
func (c *Client) GetTestID() (string, error) {
	url := fmt.Sprintf("https://%s/id", c.apiDomain)
	data, err := c.getContent(url)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

// PerformFakePings sends fake ping requests to test DNS leakage
func (c *Client) PerformFakePings(testID string) {
	var wg sync.WaitGroup

	// Send 10 fake ping requests concurrently
	for i := 0; i <= 10; i++ {
		urlPing := fmt.Sprintf("https://%d.%s.%s", i, testID, c.apiDomain)
		wg.Add(1)
		go func(url string) {
			defer wg.Done()
			// We ignore errors here as these are just fake pings
			c.httpClient.Get(url)
		}(urlPing)
	}
	wg.Wait()
}

// GetResults retrieves test results from the API
func (c *Client) GetResults(testID string) ([]model.Block, error) {
	url := fmt.Sprintf("https://%s/dnsleak/test/%s?json", c.apiDomain, testID)
	data, err := c.getContent(url)
	if err != nil {
		return nil, err
	}

	var blocks []model.Block
	err = json.Unmarshal(data, &blocks)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal response: %v", err)
	}

	return blocks, nil
}

// getContent fetches content from a URL
func (c *Client) getContent(url string) ([]byte, error) {
	resp, err := c.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("GET error: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("status error: %v", resp.StatusCode)
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read body error: %v", err)
	}

	return data, nil
}
