using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using API.Filters;
using BasicAuthentication;

namespace BasicAuthentication.Controllers
{
    public class HistoriesController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Histories
        public IQueryable<History> GetHistory()
        {
            return db.History;
        }
        [AllowAnonymous]
        // GET: api/Histories/5
        [ResponseType(typeof(HistoryArticles))]
        public IHttpActionResult GetHistoryArticles(int id)
        {
            HistoryArticles historyArticles = db.HistoryArticles.Find(id);
            if (historyArticles == null)
            {
                return NotFound();
            }

            return Ok(historyArticles);
        }

        // PUT: api/Histories/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutHistory(int id, History history)
        {

            if (id != history.ID)
            {
                return BadRequest();
            }

            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string commandStr =
                    $"EXEC HistoryRating @id = '{history.ID}'," +
                    $" @rating = '{history.Rating}'";
                connection.Open();
                SqlCommand command = new SqlCommand(commandStr, connection);
                number = command.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            if (number != null)
                return Ok();

            return null;
        }

        // POST: api/Histories
        [ResponseType(typeof(History))]
        public IHttpActionResult PostHistory(History history)
        {

            db.History.Add(history);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (HistoryExists(history.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = history.ID }, history);
        }

        // DELETE: api/Histories/5
        [ResponseType(typeof(History))]
        public IHttpActionResult DeleteHistory(int id)
        {
            History history = db.History.Find(id);
            if (history == null)
            {
                return NotFound();
            }

            db.History.Remove(history);
            db.SaveChanges();

            return Ok(history);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool HistoryExists(int id)
        {
            return db.History.Count(e => e.ID == id) > 0;
        }
    }
}