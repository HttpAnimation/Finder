import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class Finder {

    public static void main(String[] args) {
        try {
            // Read the Repos.json file
            String configFile = "Configs/Repos.json";
            String reposJson = readConfigFile(configFile);

            // Parse the JSON array
            String[] repoArray = parseJsonArray(reposJson);

            // Iterate through each repository
            for (String repoData : repoArray) {
                // Parse the repository data JSON
                String[] repoDataArray = parseJsonObject(repoData);

                // Print the repository information
                System.out.println("Name: " + repoDataArray[0]);
                System.out.println("Description: " + repoDataArray[1]);
                System.out.println("Developer: " + repoDataArray[2]);
                System.out.println("Install Command: " + repoDataArray[3]);
                System.out.println("Remove Command: " + repoDataArray[4]);
                System.out.println("Run Command: " + repoDataArray[5]);
                System.out.println("Logo: " + repoDataArray[6]);
                System.out.println("Project: " + repoDataArray[7]);
                System.out.println("\n---\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String readConfigFile(String filePath) throws IOException {
        StringBuilder content = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                Finder.class.getClassLoader().getResourceAsStream(filePath)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
        }
        return content.toString();
    }

    private static String[] parseJsonArray(String jsonArray) {
        // Assuming the input format is "[{\"Repo-1\": \"...\"}, ...]"
        String[] parts = jsonArray.substring(1, jsonArray.length() - 1).split("\\},\\s*\\{");
        for (int i = 0; i < parts.length; i++) {
            parts[i] = "{" + parts[i] + "}";
        }
        return parts;
    }

    private static String[] parseJsonObject(String jsonObject) {
        // Assuming the input format is "{\"Name\":\"...\",\"Description\":\"...\",...}"
        String[] keyValuePairs = jsonObject.substring(1, jsonObject.length() - 1).split(",\\s*");
        String[] result = new String[keyValuePairs.length];

        for (int i = 0; i < keyValuePairs.length; i++) {
            String[] pair = keyValuePairs[i].split(":");
            result[i] = pair[1].replaceAll("\"", "");
        }

        return result;
    }
}
