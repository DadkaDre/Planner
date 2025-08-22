FROM gradle:8.13-jdk21 as builder
# в рамках первого этапа копируем необходимые файлы Maven-проекта в директорию /app внутри образа
WORKDIR /app
COPY build.gradle settings.gradle /app/
COPY gradle /app/gradle
copy src /app/src
# запускаем файл с прописанным именем
RUN  gradle bootJar --no-daemon

FROM eclipse-temurin:21-jre-alpine
# переменная окружения
ENV APP_HOME=/app JAR_FILE=planner-app.jar
# задали рабочую директорию проекта
WORKDIR $APP_HOME
# создаем рабочую группу и пользователя и добавляем его туда
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# скопирует файлы jar в директорию /app внутри контейнера и поменяет пользователя на вновь созданного
COPY --from=builder --chown=appuser:appgroup /app/build/libs/$JAR_FILE app.jar
# переключаемся на пользователя
USER appuser
# запускает java из файла app.jar приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
