# 1. Basic Variables and Math
x <- 10
y <- 20
sum <- x + y
print(paste("Sum of x and y:", sum))

# 2. Vectors (1D Arrays)
numbers <- c(1, 2, 3, 4, 5)  # Create a vector
mean_value <- mean(numbers)   # Calculate mean
print(paste("Mean of numbers:", mean_value))

# 3. Data Frame (Table-like Structure)
data <- data.frame(
  Name = c("Alice", "Bob", "Charlie"),
  Age = c(25, 30, 22),
  Score = c(88, 92, 85)
)
print("Data Frame:")
print(data)

# 4. Basic Plot (VS Code will show it in the Plot tab)
plot(numbers, type = "o", col = "blue", main = "Simple Plot", xlab = "Index", ylab = "Value")

# 5. Custom Function
square <- function(a) {
  return(a^2)
}
print(paste("Square of 5:", square(5)))

print(paste("Current directory:", getwd()))
print("Files in this folder:")
print(list.files())

# List files inside 'data' folder
print(list.files("data"))

# List files inside 'data_prep' folder
print(list.files("data_prep"))

loaded_data <- load("adsl.rda")  # Returns object name(s)
