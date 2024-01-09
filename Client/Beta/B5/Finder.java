import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

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
                if (repoDataArray.length >= 8) {
                    System.out.println("Name: " + repoDataArray[0]);
                    System.out.println("Description: " + repoDataArray[1]);
                    System.out.println("Developer: " + repoDataArray[2]);
                    System.out.println("Install Command: " + repoDataArray[3]);
                    System.out.println("Remove Command: " + repoDataArray[4]);
                    System.out.println("Run Command: " + repoDataArray[5]);
                    System.out.println("Logo: " + repoDataArray[6]);
                    System.out.println("Project: " + repoDataArray[7]);
                    System.out.println("\n---\n");
                } else {
                    System.out.println("Invalid JSON data for a repository");
                }
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
        String[] keyValuePairs = jsonObject.split(",");
        String[] result = new String[8];

        for (String pair : keyValuePairs) {
            String[] keyValue = pair.split(":");
            if (keyValue.length == 2) {
                String key = keyValue[0].trim().replaceAll("\"", "");
                String value = keyValue[1].trim().replaceAll("\"", "");
                
                switch (key) {
                    case "Name": result[0] = value; break;
                    case "Description": result[1] = value; break;
                    case "Developer": result[2] = value; break;
                    case "Install-Command": result[3] = value; break;
                    case "Remove-Command": result[4] = value; break;
                    case "Run-Command": result[5] = value; break;
                    case "Logo": result[6] = value; break;
                    case "Project": result[7] = value; break;
                }
            }
        }

        return result;
    }
}
