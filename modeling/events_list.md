# Auth Service

### Producing
#### CUD events
|name|consumers|
|-|-|
|Account CUD events| Tasks Service, Accounting Service, Analytics Service|

#### BE
|name|consumers|
|-|-|
|Auth.RoleChanged| Tasks Service, Accounting Service, Analytics Service|

### Consuming
No consuming events

# Tasks Service

### Producing
#### CUD events
|name|consumers|
|-|-|
|Task CUD events| Accounting Service, Analytics Service|


#### BE
|name|consumers|
|-|-|
|Tasks.Added| Accounting Service, Analytics Service|
|Tasks.Assigned| Accounting Service, Analytics Service|
|Tasks.Completed| Accounting Service, Analytics Service|

### Consuming

#### CUD events
|name|producer|reason|
|-|-|-|
|Account CUD events| Auth Service| Для синхронизации данных аккаунта|
#### BE
|name|producer|reason|
|-|-|-|
|Auth.RoleChanged| Auth Service|сохранять новую роль внутри сервиса Tasks|

# Accounting Service

## Producing

### CUD events
|name|consumers|
|-|-|
|Balance CUD events| Analytics Service|

### BE
|name| consumers|
|-|-|
|Accounting.TaskCostAndFeeCalculated|Analytics Service|
|Accounting.MoneyWithdrawn| Accounting Service, Analytics Service|
|Accounting.MoneyAccrued| Accounting Service, Analytics Service|
|Accounting.EmployeeEarningsCalculated| Accounting Service|
|Accounting.EmployeeEarningSent| ?|
|Accounting.EmployeeEarningPaid| ?|
|Accounting.BalanceAuditChanged| ?|

## Consuming

### CUD events
|name|producer|reason|
|-|-|-|
|Account CUD events| Auth Service|синхронизировать данные аккаунта|
|Tasks CUD events| Tasks Service|синхронизировать данные таски|


### BE
|name| producer|reason|
|-|-|-|
|Auth.RoleChanged| Auth Service|сохранять актуальную роль аккаунта|
|Tasks.Added| Tasks Service|создавать таску внутри текущего сервиса|
|Tasks.Assigned| Tasks Service|для снятия денег со счета сотрудника, получившего задачу|
|Tasks.Completed| Tasks Service|для начисления денег на счет сотрудника, завершившего задачу|
|Accounting.DayEnded| Accounting Service|для запуска расчета заработанных сумм и вывода денег со счета сотрудников|
|Accounting.EmployeeEarningsCalculated| Accounting Service|для отправки заработанных сумм на email сотрудников|
|Accounting.MoneyWithdrawn| Accounting Service| для записи в аудит лог счета сотрудника|
|Accounting.MoneyAccrued| Accounting Service| для записи в аудит лог счета сотрудника|
|Accounting.EmployeeEarningPaid| Accounting Service|для записи в аудит лог счета сотрудника|

# Analytics Service

## Producing
No producing events

## Consuming

### CUD events
|name| producer|reason|
|-|-|-|
|Account CUD events| Auth Service|синхронизировать данные аккаунта|
|Task CUD events| Tasks Service|синхронизировать данные таски|
|Balance CUD events | Accounting Service|создавать или удалять баланс аккаунта|

## BE
|name| producer| reason|
|-|-|-|
|Auth.RoleChanged| Auth Service|сохранять новую роль аккаунта|
|Tasks.Added| Tasks Service|добавлять новые таски|
|Tasks.Completed| Tasks Service|для обновления статуса таски и получения самой дорогой таски по периодам|
|Accounting.TaskCostAndFeeCalculated| Accounting Service|для сохранения цены и платежа за таску|
|Accounting.MoneyWithdrawn| Accounting Service| для актуализации баланса аккаунта|
|Accounting.MoneyAccrued| Accounting Service| для актуализации баланса аккаунта|
