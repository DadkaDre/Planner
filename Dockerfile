FROM eclipse-temurin:21-jdk-alpine
# переменная окружения
ARG APP_HOME=/app JAR_FILE=Planner-1.0-SNAPSHOT.jar
# задали рабочую директорию проекта
WORKDIR $APP_HOME
# создаем рабочую группу и пользователя и добавляем его туда
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# скопирует файлы jar в директорию /app внутри контейнера и поменяет пользователя на вновь созданного
COPY --chown=appuser:appgroup build/libs/$JAR_FILE app.jar
# переключаемся на пользователя
USER appuser
# запускает java из файла app.jar приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
