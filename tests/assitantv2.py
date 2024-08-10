# pip install openai --upgrade
import os
 
import json
import time
from openai import OpenAI
import requests

# Set API key
# os.environ["OPENAI_API_KEY"] = OPENAI_API_KEY


def exa_search(query):
    print(f"Received query: {query}")
    
    url = "https://api.exa.ai/search"
    payload = { "query": query }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "x-api-key": os.environ["API_KEY_EXA"]
    }
    
    try:
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()  # Ensure we catch HTTP errors
        content = response.json()
        print(f"Response content: {content}")
        return json.dumps(content)
#         return content
    except Exception as e:
        print(f"Error occurred: {e}")
        return "An error occurred while processing your request."
    
# Define the perplexity_search function
def perplexity_search(query):
    print(f"Received query: {query}")
    client = OpenAI(api_key=YOUR_API_KEY, base_url="https://api.perplexity.ai")
    messages = [
        {"role": "system", "content": "You are an artificial intelligence assistant and you need to engage in a helpful, detailed, polite conversation with a user."},
        {"role": "user", "content": query},
    ]
    try:
        response = client.chat.completions.create(model="llama-3-sonar-small-32k-online", messages=messages)
        content = response.choices[0].message.content
        print(f"Response content: {content}")
        return content
    except Exception as e:
        print(f"Error occurred: {e}")
        return "An error occurred while processing your request."

# Function to create or load an assistant
def create_or_load_assistant(client):
    assistant_file_path = "assistant.json"
    if os.path.exists(assistant_file_path):
        with open(assistant_file_path, "r") as file:
            assistant_data = json.load(file)
            assistant_id = assistant_data["assistant_id"]
            print(f"Loaded existing assistant ID: {assistant_id}")
    else:
        assistant = client.beta.assistants.create(
            instructions="You are a helpful assistant that can perform searches using the EXA AI API. Expect the returned result set in JSON format, and while printing that output, use Markdown language for clarity.",
            model="gpt-4o-mini",
            tools=[
                {
                    "type": "function",
                    "function": {
                        "name": "exa_search",
                        "description": "This function performs a search using the EXA AI API. The input to the function is a JSON object. The function returns the search results as a JSON object.",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "query": {
                                    "type": "string",
                                    "description": "The search query string.",
                                },
                            },
                            "required": ["query"],
                        },
                    },
                },
            ]
        )


        with open(assistant_file_path, "w") as file:
            json.dump({"assistant_id": assistant.id}, file)
            print(f"Created a new assistant and saved the ID: {assistant.id}")
        assistant_id = assistant.id
    return assistant_id

# Main function
def main():
    client = OpenAI()

    # Create or load assistant
    assistant_id = create_or_load_assistant(client)
    print(f"Using assistant ID: {assistant_id}")

    # Create a new thread
    thread = client.beta.threads.create()
    print(f"Thread created with ID: {thread.id}")

    # Run a loop where the user can ask questions
    while True:
        text = input("What's your question? (Type 'quit' to exit)\n")
        if text.lower() == 'quit':
            break

        # Create a user message in the thread
        user_message = client.beta.threads.messages.create(
            thread_id=thread.id,
            role="user",
            content=text
        )

        # Run the assistant to get a response
        run = client.beta.threads.runs.create(
            thread_id=thread.id,
            assistant_id=assistant_id
        )

        # Polling for the run status
        i = 0
        while run.status not in ["completed", "failed", "requires_action"]:
            if i > 0:
                time.sleep(10)
            run = client.beta.threads.runs.retrieve(
                thread_id=thread.id,
                run_id=run.id
            )
            i += 1
            print(run.status)

        # Handle required actions
        if run.status == "requires_action":
            tools_to_call = run.required_action.submit_tool_outputs.tool_calls
            print(len(tools_to_call))
            print(tools_to_call)

            tool_output_array = []

            for each_tool in tools_to_call:
                tool_call_id = each_tool.id  # Correct attribute for tool_call_id
                function_name = each_tool.function.name
                function_args = json.loads(each_tool.function.arguments)  # Parse the JSON string

                print(f"Tool ID: {tool_call_id}")
                print(f"Function to call: {function_name}")
                print(f"Parameters to use: {function_args}")

                # Call the exa_search function directly
                if function_name == "exa_search":
                    output = exa_search(function_args['query'])

                tool_output_array.append({"tool_call_id": tool_call_id, "output": output})

            print(tool_output_array)

            # Submit the tool outputs
            run = client.beta.threads.runs.submit_tool_outputs(
                thread_id=thread.id,
                run_id=run.id,
                tool_outputs=tool_output_array
            )

            # Check the run operation status again
            i = 0
            while run.status not in ["completed", "failed", "requires_action"]:
                if i > 0:
                    time.sleep(10)
                run = client.beta.threads.runs.retrieve(
                    thread_id=thread.id,
                    run_id=run.id
                )
                i += 1
                print(run.status)

        # Retrieve the assistant's response message
        response_message = None
        messages = client.beta.threads.messages.list(thread_id=thread.id).data
        for message in messages:
            if message.role == "assistant":
                response_message = message
                break

        if response_message:
            print(f"Assistant response: {response_message.content}\n")
        else:
            print("No assistant response found.\n")

if __name__ == "__main__":
    main()
